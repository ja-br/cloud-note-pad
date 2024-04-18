# Serverless Note-Taking Application

This application allows users to create, read, update, and delete notes in a serverless architecture, leveraging AWS services like Amazon API Gateway, AWS Lambda, Amazon DynamoDB, and Amazon S3. The frontend is a Single Page Application (SPA) built with React.

## Features

- **Create Notes**: Users can add new notes with titles and content.
- **View Notes**: Users can browse through all saved notes.
- **Edit Notes**: Users have the ability to update the details of their notes.
- **Delete Notes**: Notes that are no longer needed can be removed.

## Architecture

The application architecture utilizes:

- **Amazon API Gateway**: Exposes RESTful endpoints.
- **AWS Lambda**: Executes application logic without server provisioning.
- **Amazon DynamoDB**: Serves as a fast, flexible NoSQL database service for application data.
- **Amazon S3**: Hosts static website content for the frontend.

## Prerequisites

- AWS account.
- AWS CLI, configured with account credentials.
- Node.js and npm (for deploying Lambda functions and React application).

## Repository Structure

This repository contains the source code for the serverless application:

- `frontend/`: Contains the React application source code.
- `lambda/`: Contains AWS Lambda function definitions.

Infrastructure management has been moved to a separate repository named `aws-config`, which contains all Terraform configurations.

## Getting Started

### Setting Up the Backend Infrastructure

Please refer to the `aws-config` repository for instructions on deploying and managing the AWS infrastructure using Terraform.

### Deploying the Frontend

1. **Build the React Application**

   Navigate to the `frontend` directory and install dependencies:

   ```bash
   cd frontend/
   npm install
   ```

Build the application:

```
npm run build
```

1. **Deploy to Amazon S3**

   Upload the build artifacts to your S3 bucket configured for static website hosting. This can be done via the AWS CLI or the AWS Management Console.

   Example AWS CLI command:

   ```
   aws s3 sync build/ s3://<YOUR_BUCKET_NAME> --acl public-read
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