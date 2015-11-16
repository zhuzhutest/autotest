require 'json'
require 'net/http'

CURRENT_USER = 'admin'
GRID_SERVICE_IP = '127.0.0.1'
GRID_SERVICE_PORT = '20120'

def run_command(method, cmd, params = {})
    # add  current user info
    params[:current_user] = CURRENT_USER 
           
    response = DDI::Command.new(method, GRID_SERVICE_IP, GRID_SERVICE_PORT, cmd, params, 0).run
    [response['code'], response['ret']]
end   
27fd3a944212a811ba9c60a60025c8db

