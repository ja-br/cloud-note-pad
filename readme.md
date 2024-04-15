# **Serverless Note-Taking Application**

This application allows users to create, read, update, and delete notes in a serverless architecture, leveraging AWS services like Amazon API Gateway, AWS Lambda, Amazon DynamoDB, and Amazon S3. The frontend is a Single Page Application (SPA) built with React.

## **Features**

- **Create Notes**: Users can add new notes with titles and content.
- **View Notes**: Users can browse through all saved notes.
- **Edit Notes**: Users have the ability to update the details of their notes.
- **Delete Notes**: Notes that are no longer needed can be removed.

## **Architecture**

The application architecture utilizes:

- **Amazon API Gateway**: Exposes RESTful endpoints.
- **AWS Lambda**: Executes application logic without server provisioning.
- **Amazon DynamoDB**: Serves as a fast, flexible NoSQL database service for application data.
- **Amazon S3**: Hosts static website content for the frontend.

## **Prerequisites**

- AWS account.
- AWS CLI, configured with account credentials.
- Node.js and npm (for deploying Lambda functions and React application).
- Terraform, for infrastructure as code deployment.

## **Getting Started**

### **Deploying the Backend with Terraform**

1. **Terraform Initialization**

   Navigate to the `terraform` directory and initialize Terraform:

   ```
   shCopy codecd terraform/
   terraform init
   ```
2. **Deploy Infrastructure**

   Apply the Terraform configuration to deploy AWS resources:

   ```
   shCopy codeterraform apply
   ```

   Confirm the deployment when prompted.
3. **Lambda Functions**

   After the infrastructure is deployed, update the Lambda functions with your application logic, referencing the newly created resources as needed.

### **Setting Up the Frontend**

1. **Build the React Application**

   Navigate to the `frontend` directory and install dependencies:

   ```
   shCopy codecd frontend/
   npm install
   ```

   Build the application:

   ```
   shCopy codenpm run build
   ```
2. **Deploy to Amazon S3**

   Upload the build artifacts to your S3 bucket configured for static website hosting. This can be done via the AWS CLI or the AWS Management Console.

   Example AWS CLI command:

   ```
   shCopy codeaws s3 sync build/ s3://<YOUR_BUCKET_NAME> --acl public-read
   ```

### **Testing the Application**

- Access your S3 bucket's public URL to interact with the frontend and test the application functionalities.

## **API Reference**

Detailed API endpoint documentation including methods, URL paths, and data parameters for operations such as creating, listing, updating, and deleting notes.

## **Security**

- Utilize AWS IAM for secure access management to AWS services and resources.
- Implement authentication and authorization with Amazon Cognito to protect user data.

## **License**

This project is licensed under the MIT License.