package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	host := os.Getenv("HOST")
	port := os.Getenv("PORT")
	route := os.Getenv("ROUTE_PATH")
	namespace := os.Getenv("NAMESPACE")
	pod_name := os.Getenv("POD_NAME")
	pod_ip := os.Getenv("POD_IP")

	http.HandleFunc(route, func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Namespace: "+namespace+"\n")
		fmt.Fprintf(w, "Pod Name: "+pod_name+"\n")
		fmt.Fprintf(w, "Pod IP: "+pod_ip+"\n")
	})

	fmt.Printf("Starting server at " + host + ":" + port + route + "\n")
	if err := http.ListenAndServe(host+":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
