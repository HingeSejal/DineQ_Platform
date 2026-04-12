import urllib.request
import urllib.parse
import json

def test_login(username, password):
    url = 'http://localhost:8080/auth'
    data = urllib.parse.urlencode({'username': username, 'password': password}).encode()
    req = urllib.request.Request(url, data=data)
    try:
        response = urllib.request.urlopen(req)
        print(f"Login {username}: Response URL: {response.geturl()}, HTTP Status: {response.getcode()}")
        return response.read().decode('utf-8')
    except urllib.error.HTTPError as e:
        print(f"Login {username}: HTTP Error: {e.code}")
        return ""

def test_register(username, password):
    url = 'http://localhost:8080/register'
    data = urllib.parse.urlencode({'username': username, 'password': password}).encode()
    req = urllib.request.Request(url, data=data)
    try:
        response = urllib.request.urlopen(req)
        print(f"Register {username}: Response URL: {response.geturl()}, HTTP Status: {response.getcode()}")
        return response.read().decode('utf-8')
    except urllib.error.HTTPError as e:
        print(f"Register {username}: HTTP Error: {e.code}")
        return ""

# Test strict password constraint
html = test_register("newuser", "Test@123")
if "alert-error" in html:
    print("Found error in register response!")
    # extracting error message loosely
    idx = html.find("alert-error")
    print(html[idx:idx+150])

html = test_login("newuser", "Test@123")
if "alert-error" in html:
    print("Found error in login response!")
    idx = html.find("alert-error")
    print(html[idx:idx+150])

html = test_login("admin_palace", "user")
print("Admin Palace response snippet:", html[:100])
