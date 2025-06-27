[⚠️ Suspicious Content] # 🚀 Automated EC2 Instance with User Data & Basic Monitoring (CloudWatch)

This repository contains Infrastructure as Code (IaC) for deploying and automating an Amazon EC2 instance, complete with basic monitoring via AWS CloudWatch, using **Terraform**.

## ✨ Project Overview

This project focuses on the automated deployment of a virtual server (an EC2 instance) in AWS. It demonstrates how to provision the instance with initial setup tasks using user data scripts and how to establish foundational monitoring to ensure its operational health. This approach highlights efficient resource provisioning and basic operational oversight, crucial skills for a cloud engineer.

## 🌟 Key Features & Technologies

* **Infrastructure as Code (IaC):** Defined and managed entirely using [Terraform](https://www.terraform.io/).

* **Elastic Compute Cloud (EC2):** Deployment of a Linux virtual machine instance.

* **User Data Automation:** Utilising EC2 user data to automatically install and configure a web server (Apache) upon instance launch.

* **Basic Monitoring:** Implementation of a CPU utilisation alarm using [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) to alert on high resource consumption.

* **Virtual Firewall:** Configuration of an [EC2 Security Group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) to control network traffic to the instance (allowing SSH, HTTP, and HTTPS).

## 🌐 Architecture Overview

The diagram below illustrates the components deployed and their relationships:

```text
+---------------------------------------------------+
|               AWS Cloud                           |
|                                                   |
| +-----------------------------------------------+ |
| |        Your Default VPC (or existing)         | |
| |                                               | |
| | +-------------------------------------------+ | |
| | |           Security Group                  | | |
| | | (Allows SSH, HTTP, HTTPS traffic)         | | |
| | +---------------------+---------------------+ | |
| |                       |                       | |
| |                       v                       | |
| | +-------------------------------------------+ | |
| | |             EC2 Instance                  | | |
| | | (Amazon Linux 2)                          | | |
| | |   - User Data (Apache Web Server Setup)   | | |
| | +-------------------------------------------+ | |
| +-----------------------------------------------+ |
|                                                   |
| +-----------------------------------------------+ |
| |             Amazon CloudWatch                 | |
| | +-------------------------------------------+ | |
| | |             CPU Utilisation Alarm         | | |
| | | (Monitors EC2 CPU, alerts if over 80%)    | | |
| | +-------------------------------------------+ | |
| +-----------------------------------------------+ |
+---------------------------------------------------+
```

* **EC2 Instance:** The core virtual server hosting the web application.

* **Security Group:** Controls incoming and outgoing network traffic to the EC2 instance.

* **User Data:** A script executed by the EC2 instance at launch to automate software installation.

* **CloudWatch Alarm:** Monitors the EC2 instance's metrics (like CPU utilisation) and can trigger actions if thresholds are breached.

## 🚀 Deployment Steps

Follow these steps to deploy your EC2 instance with user data and CloudWatch monitoring.

### 🔧 Prerequisites

* An **AWS Account** with sufficient permissions to create EC2 instances, Security Groups, and CloudWatch alarms.

* [**AWS CLI**](https://aws.amazon.com/cli/) installed and configured with appropriate credentials.

* [**Terraform**](https://www.terraform.io/downloads.html) installed (version 1.0+ recommended).

* An existing **EC2 Key Pair** in your chosen AWS region for SSH access to the instance.

### ⚙️ Setup and Deployment

1. **Create Project Folder & Files:**
   Create a new directory (e.g., `aws-ec2-monitoring-project`) and place your `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and `.gitignore` files within it, populating them with the code provided previously.

   ```bash
   mkdir aws-ec2-monitoring-project
   cd aws-ec2-monitoring-project
   # Create/copy .tf files here
   ```

2. **Customise Variables:**
   Open your `variables.tf` file and ensure the following are correctly set:

   * `aws_region`: Should be `eu-west-2` (London) as per your preference.

   * `ami_id`: While `main.tf` uses a data source to find the latest Amazon Linux 2 AMI, you can override it here if you need a specific one.

   * `key_pair_name`: **Crucially, this MUST match the name of an existing EC2 Key Pair that you have created in your AWS account.**

3. **Initialise Terraform:**
   This command prepares your working directory, downloading the necessary AWS provider plugins.

   ```bash
   terraform init -reconfigure
   ```

4. **Review the Deployment Plan:**
   This crucial safety step shows you exactly what Terraform plans to create, modify, or destroy in your AWS account.

   ```bash
   terraform plan
   ```

   *Expect to see a summary indicating 3 resources will be added (EC2 instance, Security Group, CloudWatch Alarm).*

5. **Apply the Configuration:**
   This command executes the plan, creating the resources in your AWS account. You will be prompted to type `yes` to confirm.

   ```bash
   terraform apply
   ```

   * **What to expect:** Terraform will create the Security Group first, then the EC2 instance, and finally the CloudWatch alarm. The EC2 instance might take 15-30 seconds to fully launch.

### ✅ Verification

After `terraform apply` completes successfully, use the following methods to verify your deployment:

1. **Check the Web Server (via EC2 Public IP/DNS):**

   * From your `terraform apply` output, note the `ec2_public_ip` or `ec2_public_dns`.

   * Open a web browser and navigate to `http://<YOUR_EC2_PUBLIC_IP>` (e.g., `http://13.43.121.189`).

   * You should see the message: **"Hello from your Terraform-deployed EC2 instance!"** This confirms the EC2 instance launched and the user data script ran successfully.

2. **Verify in the AWS Management Console:**

   * Log in to the AWS Management Console (ensure you are in the **Europe (London) eu-west-2** region).

   * **EC2 Dashboard:** Go to "Instances." You should see an instance named `my-ec2-key-web-server` (or similar) with a "Running" status. Click its ID to review details.

   * **EC2 Security Groups:** Go to "Security Groups." Find `my-ec2-key-ec2-sg` and confirm it has inbound rules for ports 22 (SSH), 80 (HTTP), and 443 (HTTPS) from `0.0.0.0/0`.

   * **CloudWatch Alarms:** Go to "CloudWatch" -> "Alarms." You should see an alarm named `my-ec2-key-high-cpu-alarm`. Its status should initially be "OK" (green) as the instance's CPU usage will likely be low at first.

### 🗑️ Cleanup (Optional)

To tear down all the AWS resources created by this project and avoid incurring further charges:

1. **Navigate to your project folder:**

   ```bash
   cd C:\Path\To\Your\aws-ec2-monitoring-project
   ```

2. **Destroy Terraform Resources:**

   ```bash
   terraform destroy
   ```

   *This will ask for confirmation (`yes`). Be absolutely sure you want to delete all associated resources before proceeding.*

## 🧠 Key Learnings & Interview Highlights

This project provides invaluable hands-on experience for an Associate Cloud Engineer role, covering several key competencies:

* **Core AWS Services (EC2 & CloudWatch):**

  * "I gained direct experience deploying and configuring virtual servers (EC2 instances) and setting up essential monitoring (CloudWatch alarms) for operational health, which are fundamental to managing cloud infrastructure."

* **Automation with User Data:**

  * "I utilised EC2 user data to automate the bootstrapping of the instance, including installing a web server. This demonstrates practical automation skills, reducing manual effort and ensuring consistent instance configurations."

* **Infrastructure as Code (IaC):**

  * "Continuing my IaC journey, I used Terraform to define the entire EC2 deployment and monitoring setup. This reinforces the principles of repeatable, version-controlled, and declarative infrastructure management."

* **Network Security Fundamentals:**

  * "By configuring an EC2 Security Group, I applied fundamental network security principles, controlling inbound (SSH, HTTP, HTTPS) and outbound traffic to the instance, which is critical for protecting cloud resources."

* **Operational Awareness & Monitoring:**

  * "Implementing a CloudWatch CPU alarm showed my understanding of basic monitoring principles. It highlighted the importance of proactively identifying and alerting on potential performance bottlenecks in a cloud environment."

## 📄 Licence

This project is open-sourced under the [MIT Licence](LICENSE).