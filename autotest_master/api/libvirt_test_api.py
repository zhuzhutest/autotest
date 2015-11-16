#-*- coding: UTF-8 -*- 
import os
import re
import sys
import shutil
import glob
import string
import logging
import commands
from autotest.client.tools import JUnit_api as api
from autotest.client.shared import error
from autotest.client import utils, test, os_dep
from datetime import date


class Report():

    class testcaseType(api.testcaseType):

        def __init__(self, classname=None, name=None, time=None, error=None,
                     failure=None, skip=None):
            api.testcaseType.__init__(self, classname, name, time, error,
                                      failure)
            self.skip = skip
            self.system_out = None
            self.system_err = None

        def exportChildren(self, outfile, level, namespace_='',
                           name_='testcaseType', fromsubclass_=False):
            api.testcaseType.exportChildren(
                self, outfile, level, namespace_, name_, fromsubclass_)
            if self.skip is not None:
                self.skip.export(outfile, level, namespace_, name_='skipped')
            if self.system_out is not None:
                outfile.write(
                    '<%ssystem-out><![CDATA[%s]]></%ssystem-out>\n' % (
                        namespace_,
                        self.system_out,
                        namespace_))
            if self.system_err is not None:
                outfile.write(
                    '<%ssystem-err><![CDATA[%s]]></%ssystem-err>\n' % (
                        namespace_,
                        self.system_err,
                        namespace_))

        def hasContent_(self):
            if (
                self.system_out is not None or
                self.system_err is not None or
                self.error is not None or
                self.failure is not None or
                self.skip is not None
            ):
                return True
            else:
                return False

    class failureType(api.failureType):
        def exportAttributes(self, outfile, level, already_processed, namespace_='', name_='failureType'):
            if self.message is not None and 'message' not in already_processed:
                already_processed.append('message')
                outfile.write(' message="%s"' % self.message)
            if self.type_ is not None and 'type_' not in already_processed:
                already_processed.append('type_')
                outfile.write(' type="%s"' % self.type_)

    class errorType(api.errorType):
        def exportAttributes(self, outfile, level, already_processed, namespace_='', name_='errorType'):
            if self.message is not None and 'message' not in already_processed:
                already_processed.append('message')
                outfile.write(' message="%s"' % self.message)
            if self.type_ is not None and 'type_' not in already_processed:
                already_processed.append('type_')
                outfile.write(' type=%s' % self.type_)

    class skipType(api.failureType):
        pass

    class testsuite(api.testsuite):

        def __init__(self, name=None, skips=None):
            api.testsuite.__init__(self, name=name)
            self.skips = api._cast(int, skips)

        def exportAttributes(
                self, outfile, level, already_processed,
                namespace_='', name_='testsuite'):
            api.testsuite.exportAttributes(self,
                                           outfile, level, already_processed,
                                           namespace_, name_)
            if self.skips is not None and 'skips' not in already_processed:
                already_processed.append('skips')
                outfile.write(' skipped="%s"' %
                              self.gds_format_integer(self.skips,
                                                      input_name='skipped'))

    def __init__(self, fail_diff=False):
        self.ts_dict = {}
        self.fail_diff = fail_diff

    def save(self, filename):
        """
        Save current state of report to files.
        """
        testsuites = api.testsuites()
        for ts_name in self.ts_dict:
            ts = self.ts_dict[ts_name]
            testsuites.add_testsuite(ts)
        with open(filename, 'w') as fp:
            testsuites.export(fp, 0)

    def update(self, testname, ts_name, result, log, error_msg, duration):
        """
        Insert a new item into report.
        """
        def escape_str(inStr):
            """
            Escape a string for HTML use.
            """
            s1 = (isinstance(inStr, basestring) and inStr or
                  '%s' % inStr)
            s1 = s1.replace('&', '&amp;')
            s1 = s1.replace('<', '&lt;')
            s1 = s1.replace('>', '&gt;')
            s1 = s1.replace('"', "&quot;")
            return s1

        if not ts_name in self.ts_dict:
            self.ts_dict[ts_name] = self.testsuite(name=ts_name)
            ts = self.ts_dict[ts_name]
            ts.failures = 0
            ts.skips = 0
            ts.tests = 0
            ts.errors = 0
        else:
            ts = self.ts_dict[ts_name]

        tc = self.testcaseType()
        tc.name = testname
        tc.time = duration

        # Filter non-printable characters in log
        log = ''.join(s for s in unicode(log, errors='ignore')
                      if s in string.printable)
        tc.system_out = log

        error_msg = [escape_str(l) for l in error_msg]

        if 'FAIL' in result:
            error_msg.insert(0, 'Test %s has failed' % testname)
            tc.failure = self.failureType(
                message='&#10;'.join(error_msg),
                type_='Failure')
            ts.failures += 1
        elif 'TIMEOUT' in result:
            error_msg.insert(0, 'Test %s has timed out' % testname)
            tc.failure = self.failureType(
                message='&#10;'.join(error_msg),
                type_='Timeout')
            ts.failures += 1
        elif 'ERROR' in result or 'INVALID' in result:
            error_msg.insert(0, 'Test %s has encountered error' % testname)
            tc.error = self.errorType(
                message='&#10;'.join(error_msg),
                type_='Error')
            ts.errors += 1
        elif 'SKIP' in result:
            error_msg.insert(0, 'Test %s is skipped' % testname)
            tc.skip = self.skipType(
                message='&#10;'.join(error_msg),
                type_='Skip')
            ts.skips += 1
        elif 'DIFF' in result and self.fail_diff:
            error_msg.insert(0, 'Test %s results dirty environment' % testname)
            tc.failure = self.failureType(
                message='&#10;'.join(error_msg),
                type_='DIFF')
            ts.failures += 1
        ts.add_testcase(tc)
        ts.tests += 1
        ts.timestamp = date.isoformat(date.today())


class libvirt_test_api(test.test):
    version = 1

    def setup(self, tarball='libvirt-test-API.tar.gz'):
        tarpath = utils.unmap_url(self.bindir, tarball)
        utils.extract_tarball_to_dir(tarpath, self.srcdir)
    def initialize(self):
        try:
            import pexpect
        except ImportError:
            raise error.TestError("Missing python library pexpect. You have to "
                                  "install the package python-pexpect or the "
                                  "equivalent for your distro")
        try:
            os_dep.command("nmap")
        except ValueError:
            raise error.TestError("Missing required command nmap. You have to"
                                  "install the package nmap or the equivalent"
                                  "for your distro")

    def get_tests_from_cfg(self, cfg, item):
        """
        Get all available tests for the given item in the config file cfg.
        :param cfg: Path to config file.
        :param item: Item that we're going to find tests for.
        """
        flag = 0
        testcases = []
        cfg = open(cfg, "r")
        for line in cfg.readlines():
            line = line.strip()

            if line.startswith('#'):
                continue

            if flag == 0 and not line:
                continue

            if item == line[:-1]:
                flag = 1
                continue

            if flag == 1 and not line:
                flag = 0
                break

            if flag == 1 and line.endswith('.conf'):
                testcases.append(line)
                continue

        cfg.close()
        return testcases


    def parase_result(self, result, conf_name, report, test_num):
        """parase the result to status, err_msg, res
        """
        conf_name = conf_name[:-5]
        if test_num < 10:
            str_num = "0" + str(test_num)
        else:
            str_num = str(test_num)
        conf_name = str_num + "_" + conf_name
        state = "FINISH"
        start_separate = "------------------------------------------------"
        finish_separate = "---------------------------------------------"
        full_separate = "--------------------------------------------------------------------------------------------------------------------------------"
        log_file_name = ""
        export_file = "xunit_result.xml"
        lines = result.stderr.splitlines()
        for line in lines:
            if "libvirt_test001" in line:
                log_file_name = line.split()[2]
                break 
        log_file = open(log_file_name, "r")
        for line in log_file.readlines():
            print line
            if len(line.split()) == 0:
                continue
            # split the conf log for different cases
            if (start_separate in line) and (len(line.split()) == 3) and (state == "FINISH"):
                state = "RUNNING"
                item = line.split()[1]
                status = ""
                err_msg = []
                log_output = []
                log_output.append(line)
                continue
            elif (finish_separate in line) and (len(line.split()) == 4) and (state == "RUNNING"):
                state = "RESULT"
                log_output.append(line)
                status = line.split()[2]
                continue
            elif (full_separate in line) and (state == "RESULT"):
                state = "FINISH"
                log_output.append(line)
                report.update(item, conf_name, status, ''.join(log_output), err_msg, 0.0)
                continue
            elif state == "RUNNING":
                log_output.append(line)
                if "ERROR" in line:
                    err_msg.append(line)

        log_file.close()
        sys.stdout.flush()
        report.save(export_file)

        return status, result, err_msg



    def get_cmds_from_cfg(self, cmd_cfg):
        cf = open(cmd_cfg, 'r')
        cmd_list = []
        for line in cf.readlines():
            line = line.strip()

            if not line or line.startswith('#'):
                continue
            else:
                cmd_list.append(line)

        cf.close()
        return cmd_list

    def run_once(self, item=''):
        if not item:
            raise error.TestError('No test item provided')

        logging.info('Testing item %s', item)

        cfg_files = glob.glob(os.path.join(self.bindir, '*.cfg'))
        for src in cfg_files:
            basename = os.path.basename(src)
            dst = os.path.join(self.srcdir, basename)
            shutil.copyfile(src, dst)

        config_files_cfg = os.path.join(self.bindir, 'config_files.cfg')
        cmd_cfg = os.path.join(self.bindir, 'cmd.cfg')
        test_items = self.get_tests_from_cfg(config_files_cfg, item)
        cmd_items = self.get_cmds_from_cfg(cmd_cfg)
        if not test_items:
            raise error.TestError('No test available for item %s in '
                                  'config_files.cfg' % item)

        os.chdir(self.srcdir)
        failed_tests = []
        report = Report()
        test_list = [(test_items[i], i) for i in range(len(test_items))]

        for test_item in test_list:

            for cmd in cmd_items:
                if test_item[0] in cmd:
                    cmd_item = cmd

            if test_item[0] == "consumption_attach_detach_readonlydisk.conf":
                print "Clear ssh key"
                commands.getstatusoutput("echo > /root/.ssh/known_hosts")
            try:
                result = utils.run('python excute/virtlab.py %s' % cmd_item, ignore_status = True)
                self.parase_result(result, test_item[0], report, test_item[1])

                if test_item[0] == "consumption_domain_nfs_start.conf":
                    print "Set virt_use_nfs to on"
                    commands.getstatusoutput("setsebool -P virt_use_nfs=on")

            except error.CmdError:
                logs = glob.glob(os.path.join('log', '*'))
                for log in logs:
                    shutil.rmtree(log)
                failed_tests.append(os.path.basename(test_item[0]).split('.')[0])

        if failed_tests:
            raise error.TestFail('Tests failed for item %s: %s' %
                                 (item, failed_tests))

