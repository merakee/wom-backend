 #!/bin/bash   

 echo "		Running API tests...."

if [ "$1" == "sign_in" ];	then 

# sign in
 req='POST'
 data=' {"user":{"email":"user100@example.com","password":"password"}}'
 url="http://localhost:3000/api/v0/sign_in"

#curl  -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"user":{"email":"user100@example.com","password":"password"}}'  http://localhost:3000/api/v0/sign_in

elif [ "$1" == "sign_out" ]  ; then 

# sign out
 req='DELETE'
 data='{"user":{"email":"user100@example.com","authentication_token":"'$2'"}}'
 url="http://localhost:3000/api/v0/sign_out"

elif [ "$1" == "sign_up" ]  ; then 
# sign_up
 req='POST'
 data='{"user":{"user_type_id":"2","email":"'$2'","password":"'$3'","password_confirmation":"'$4'"}}'
 url="http://localhost:3000/api/v0/sign_up"
 url="http://wom-backend-apipie-env-p3hfvesnmb.elasticbeanstalk.com/api/v0/sign_up"
else 
# get users
 req='GET'
 data='{"user":{"email":"user100@example.com","authentication_token":"'$1'"}}'
 url='http://localhost:3000/api/v0/users/1'
fi 



if [ "$req" == "GET" ]
	then
		if [ "$data" == "" ]
	then
		curl $url
	else
		curl -H "Accept: application/json" -H "Content-type: application/json" $url"?"$data
	fi 
else #if [ "$1" != "sign_up" ] ; then 
	curl  -i -H  "Accept: application/json" -H "Content-type: application/json" -X $req -d $data  $url
	#echo -H "Accept: application/json" -H "Content-type: application/json" -X $req -d $data  $url
	#curl -H $header	-X $req -d $data $url 
	#curl -H "Content-Type: application/json" -X $req -d $data $url
fi


echo ""
echo "		Done Running API tests"
echo ""