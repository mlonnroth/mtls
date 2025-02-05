all:
	echo "Usage: make {ca|server|client|webserver|webclient|badclient1|badclient2|clean}"

ca:
	openssl req -new -x509 -nodes -days 365 -subj '/CN=MangesCA' -keyout ca.key -out ca.crt

server:
	openssl genrsa -out server.key 2048
	openssl req -new -key server.key -subj '/CN=localhost' -out server.csr
	openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -days 365 -out server.crt

client:
	openssl genrsa -out client.key 2048
	openssl req -new -key client.key -subj '/CN=MangesLaptop' -out client.csr
	openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -days 365 -out client.crt

clean:
	rm -fr *.crt *.csr *.key *~

webserver:
	node index.js &

webclient:
	curl --cacert ca.crt --key client.key --cert client.crt https://localhost:3000

badclient1:
	curl --key client.key --cert client.crt https://localhost:3000

badclient2:
	curl --cacert ca.crt https://localhost:3000

