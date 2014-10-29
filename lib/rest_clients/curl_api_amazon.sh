 #!/bin/bash   

#$host="http://wom-backend-master-env-hv2gxttyvi.elasticbeanstalk.com/"
host="http://wom-dev.freelogue.net/"
echo "		Running API tests...."

if [ "$1" == "sign_in" ];	then 
# sign in
 req='POST'
 data=' {"user":{"email":"'$2'","password":"'$3'"}}'
 url=$host"api/v0/sign_in"

elif [ "$1" == "sign_out" ]  ; then 
# sign out
 req='DELETE'
 data='{"user":{"email":"'$2'","authentication_token":"'$3'"}}'
 url=$host"api/v0/sign_out"

elif [ "$1" == "sign_up" ]  ; then 
# sign_up
 req='POST'
 data='{"user":{"user_type_id":"'$2'","email":"'$3'","password":"'$4'","password_confirmation":"'$4'"}}'
 #echo $data
 url=$host"api/v0/sign_up"
#curl -i  -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"user":{"user_type_id":"2","email":"user100@example.com","password":"password","password_confirmation":"password"}}'  $url

else 
# get contents
  echo "getting contents"
 req='GET'
 data='{"user":{"email":"'$1'","authentication_token":"'$2'"}}'
 url=$host'api/v0/contents'
fi 



if [ "$req" == "GET" ]
	then
		if [ "$data" == "" ]
	then
		curl $url
	else
		curl -H "Accept: application/json" -H "Content-type: application/json" -X $req -d $data $url
	fi 
else #if [ "$1" != "sign_up" ] ; then 
	curl  -H "Accept: application/json" -H "Content-type: application/json" -X $req -d $data  $url
	#echo -H "Accept: application/json" -H "Content-type: application/json" -X $req -d $data  $url
	#curl -H $header	-X $req -d $data $url 
	#curl -H "Content-Type: application/json" -X $req -d $data $url
fi


echo ""
echo "		Done Running API tests"
echo ""echo ""