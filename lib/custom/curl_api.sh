 #!/bin/bash   

 echo "		Running API tests...."

if [ "$1" == "sign_in" ];	then 

# sign in
#curl -i  -H "Accept: application/json" -X POST -d "email=user1@example.com&password=password"  http://localhost:3000/api/v0/users/sign_in

 req='POST'
 header="Accept: application/json"
 data="email=user1@example.com&password=password" 
 url="http://localhost:3000/api/v0/users/sign_in"

elif [ "$1" == "sign_out" ]  ; then 

# sign out
#curl -i -H "Accept: application/json" -X DELETE  http://localhost:3000/api/v0/users/sign_out --data "email=admin@example.com&auth_token=x2zVyYcCszsR1suYafSo"
 req='DELETE'
 auth_token=$2
 header="Accept: application/json"
 data="email=user1@example.com&auth_token="$auth_token 
 url="http://localhost:3000/api/v0/users/sign_out"

elif [ "$1" == "sign_up" ]  ; then 
# sign_up
#curl  http://localhost:3000/api/v0/users/sign_up?ema/api/v0/users/sign_up?email=this@that.com&password=asertgdfg&password_confirmation=sertgdfg&name=user4
 req='POST'
 auth_token=$2
 header="\"Content-Type: application/json\""
 #data='{ "user": { "name": "'$2'", "email": "'$3'", "password": "'$4'",  "password_confirmation": "'$4'"}}'
 data='{ "user": { "name": "'$2'", "email": "'$3'", "password": "'$4'"}}'
 url="http://localhost:3000/api/v0/users"

else 
# get users
 req='GET'
 header=''
#data="auth_token="$1
data="userid=user1&email=user1@example.com&password=password&auth_token="$1 
 url='http://localhost:3000/api/v0/users'
fi 



if [ "$req" == "GET" ]
	then
		if [ "$data" == "" ]
	then
		curl  $url
	else
		curl $url"?"$data
	fi 

else
	#echo -H $header	-X $req -d $data $url 
	curl -H $header	-X $req -d $data $url 
	#curl -H "Content-Type: application/json" -X POST -d '{ "user": { "userid": "user1", "email": "user1@example.com", "password": "password"}}' http://localhost:3000/api/v0/users
fi


echo ""
echo "		Done Running API tests"
echo ""