#!/usr/bin/env lua
-- Octonix Project (GPLv3) http://octonix.net
-- changes password for luci-mod-octonix manager login

require('os')
require('io')
require('math')
require('uci')
require('nixio')

charset = {}
-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
    math.randomseed(os.time())
    if length > 0 then
        return string.random(length - 1) .. charset[math.random(1, #charset)]
    else
        return ''
    end
end

function print_error(message)
    io.stderr:write(message .. '\n')
end

function exit()
    print_error('octonix-passwd: password for '..username..' is unchanged')
    os.exit(1)
end

config = uci.cursor()
username = config.get('luci_octonix', 'gui', 'username')

print('Changing password for luci-mod-octonix, username: '..username)
print('New password:')
password = io.read()
print('Retype password:')
confirmation = io.read()

if password ~= confirmation then
    print_error("Passwords don\'t match")
    exit()
end

if password == '' then
    print_error('Password can\'t be empty')
    exit()
end

salt = string.random(8)
crypted_password = nixio.crypt(password, '$1$'..salt)
config.set('luci_octonix', 'gui', 'password', crypted_password)
config.commit('luci_octonix')
print('luci-mod-octonix password for user '..username..' changed successfully')
