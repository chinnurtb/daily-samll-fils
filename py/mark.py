#!/usr/bin/python
import httplib 
import urllib
import json

def main(n):
    sum = 0
    for i in range(0,n):
        content = input("please input mark:")
        print(content)
        sum=sum+content
    print("ava mark :"+str(sum/n)+"over")

def connect():
    conn = httplib.HTTPSConnection("10.32.0.11",9081,None,None,True,10)
#    body1 = urllib.urlencode(json.dumps({"ops":[{"method":"get","url":"/ping"}],"sequential":"false"})
    body1 = json.dumps({"ops":[{"method":"get","url":"/ping"},{"method":"get","url":"/ping"}],"sequential":"false"})
    top = {"Content-type":"application/json"}
    conn.request("PUT","/test",body1, top)
    r1 = conn.getresponse()
    print r1.status,r1.reason,r1.msg,r1.read()
    conn.close()

if __name__ =="__main__":
    print("main")
    connect() 
