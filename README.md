
# CloudVPN

A self-hosted VPN solution using AWS services, offering secure and private internet connectivity for personal use. This project automates the deployment of a VPN server, generates VPN client configuration files, and stores them securely in AWS S3 with the added benefit of using AWS services for management and monitoring.

## Why CloudVPN?

Unlike commercial VPN services, a self-hosted VPN server offers significant benefits:
1. **Privacy and Control**: Full ownership of your data and traffic.
2. **Cost-Effectiveness**: Almost zero cost compared to premium VPN subscriptions (leveraging AWS Free Tier benefits).
3. **Customization**: Tailor the setup to meet specific security and performance needs.
4. **No Data Logging**: Eliminate reliance on third-party providers.
5. **Performance**: Minimize latency with server deployment in a chosen region.

## Project Architecture

<<<<<<< HEAD
![image](https://github.com/user-attachments/assets/67e5763b-f1c2-4179-b5e1-febfcb0e5d47)
=======
Project Architecture:
![alt text](<CloudVPN Architecture Diagram.png>)
>>>>>>> 9fc3fe1 (Added remote backend to store state file; User data script moved to a separate file)

The project is designed with a modular approach, separating key infrastructure components into reusable modules. These include:
1. **Compute Module**: EC2 instance provisioning and WireGuard VPN setup.
2. **IAM Role and Policy Module**: Secure permissions for EC2 to interact with S3.
3. **Storage Module**: S3 bucket creation for secure file storage.
4. **VPC Module**: Custom Virtual Private Cloud (VPC) configuration for network isolation and security.
5. **Security Group Module**: Controls network access to the EC2 instance.

## Key Features

1. **Custom VPC**: Includes private and public subnets, an internet gateway, route tables, and security groups for fine-grained access control.
2. **Automated EC2 Instance Setup**: WireGuard installation and configuration generation.
3. **Secure File Handling**: Automatic upload of `wg-client.conf` to an S3 bucket.
4. **Infrastructure as Code (IaC)**: Fully automated setup using Terraform modules.
5. **Modularity**: Reusable Terraform modules for compute, IAM, storage, and networking.

## AWS Services & Other Tools Used

* **AWS EC2**: Virtual server for WireGuard VPN.
* **AWS S3**: Secure storage for the WireGuard client configuration file.
* **AWS IAM**: Role-based access control for EC2 and S3 integration.
* **AWS VPC**: Custom networking setup for secure communication.
* **Terraform**: Infrastructure as Code for provisioning and managing AWS resources.
* **WireGuard**: Lightweight, modern VPN solution.

## Modules Breakdown

### VPC Module
* Provisions a custom VPC with private and public subnets.
* Includes an internet gateway, route tables, and security groups for controlled network traffic.
* Ensures network isolation for sensitive resources.

### Compute Module
* Provisions an EC2 instance with WireGuard VPN installed.
* Uses user data scripts to install WireGuard and generate `wg-client.conf`.

### IAM Role and Policy Modules
* Configures an IAM role with a policy allowing EC2 to upload files to the S3 bucket.
* Implements least privilege principles for secure operations.

### Storage Module
* Creates an S3 bucket to store the WireGuard configuration file.
* Configures bucket policies to restrict access only to the specific EC2 instance.

### Security Group Module
* Defines ingress and egress rules to secure the EC2 instance.
* Ensures only necessary traffic is allowed.

## Deployment Steps

1. **Prerequisites**
   * AWS CLI installed and configured with your AWS key.
   * Terraform installed.
   * AWS account with permissions to create EC2, S3, IAM, and VPC resources.

2. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/CloudVPN.git
   cd CloudVPN
   ```

3. **Update the Key Pair**
   * Change the `key_name` attribute in `/modules/compute/main.tf` to your AWS account user's key pair ID.

4. **Initialize, Validate, and Plan Terraform**
   ```bash
   terraform init
   terraform validate
   terraform plan
   ```

5. **Apply the Terraform Configuration**
   ```bash
   terraform apply
   ```
   * Confirm with `yes` when prompted.

6. **Download the Configuration File**
   * Use the AWS Console App to navigate to the S3 bucket.
   * Locate the `wg-client.conf` file and download it.

7. **Set Up WireGuard**
   * Install the WireGuard app on your device.
     ***For Android, download the [Wireguard app](https://play.google.com/store/apps/details?id=com.wireguard.android&pcampaignid=web_share) from the playstore.
     <img width="1373" alt="Screenshot 2024-11-20 at 4 15 44 PM" src="https://github.com/user-attachments/assets/1eeb5bae-a892-4389-a8c2-3a218b28120b">

   * Import the `wg-client.conf` file which you downloaded from your S3 bucket into the app.
     ![wg](https://github.com/user-attachments/assets/fdee9981-6e88-4b04-a78a-acd58e08da57)

8. **Connect to the VPN**
   * Activate the imported configuration in WireGuard.
   * Enjoy secure and private internet access!

## Security Considerations

1. **Custom VPC**
   * Ensures network isolation for the EC2 instance.
   * Security groups control access to the EC2 instance and prevent unauthorized connections.

2. **IAM Policies**
   * Restrict S3 access to the specific EC2 instance role.
   * Use the principle of least privilege.

3. **S3 Bucket**
   * Enforces strict access policies for secure file handling.

4. **Encryption**
   * Enabled server-side encryption for S3 objects.

## Expected Features in Future Phases

1. **Web Interface with User Login**
   * Add authentication and authorization for users to securely access the web dashboard.
   * Enable users to manage their VPN client configuration files.

2. **Web Access to Configuration Files**
   * Provide a simple interface for users to download the `wg-client.conf` file directly from the dashboard.

3. **VPN and AWS Usage Dashboard**
   * Visualize key metrics, such as VPN usage, connected clients, and bandwidth consumption.
   * Display AWS cost details, helping users monitor and optimize resource usage.
