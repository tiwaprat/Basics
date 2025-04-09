**Overview**
This repository contains a collection of various projects created as experiments in building and configuring infrastructure. The objective of these simple projects is to deepen the understanding of fundamental concepts and how they apply to real-world use cases.

**Project 1** This project focuses on firewall settings and iptables configuration, exploring how these configurations can impact access to resources or applications running on an EC2 instance. It highlights key aspects of network security and access control.

**Project 2**This project involves a simple Python-based application running on an EC2 instance, featuring a Flask-based user interface. The application allows users to input data, which is then stored in a MySQL database. This application is designed to integrate with other infrastructure configurations and demonstrate the interaction between different components.

**Project 3** Recently, I participated in a hackathon organized by HCL, where I worked on a project that involved creating an infrastructure using Terraform. The project required setting up an AWS Lambda function to process images uploaded to one S3 bucket and store the processed images in another S3 bucket. Attached is the functional project.

**Project 4**: This project involves creating a containerized version of the student app on a single EC2 instance. All steps are outlined in detail, along with other artifacts

**Project 5**: This project involves creating a containerized version of the student app runnning on ec2 and connected with mysql container running on another ec2 . All steps are outlined in detail, along with other artifacts in github project4. In this method, the Flask app container uses the EC2 instance's IP address (public IP, private IP, or Elastic IP) of the MySQL host to connect to the database. Rather than connecting directly to the IP address of the MySQL container, the app container uses port forwarding, relying solely on the EC2 instance's IP address. When a request is sent from the app container to the EC2 instance running MySQL, the request is directed to port 3306 on the host machine. Once the request reaches the EC2 instance, the host handles the port forwarding and directs the request to the MySQL container.
