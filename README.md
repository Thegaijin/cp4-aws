## PYTHON FLASK API AWS DEPLOYMENT AUTOMATION SCRIPT

### Instructions for CP3 deployment

If you don't have an AWS account, signup for one.

Create an AWS Identity and Access Management (IAM) user account to allow you securely control access to the AWS resources. AWS strongly recommend that you do not use the root user for your everyday tasks.

Once you sign in as the IAM user, you will be directed to the AWS Services console. Select `EC2`. On the new page, click on the `Launch Instance` button. This will lead you to a page where you can select an Amazon Machine Image.

1.  Find the `Ubuntu Server 16.04 LTS (HVM), SSD Volume Type - ami-4e79ed36` image and click the `Select` button.
2.  On the next page, ensure that the on the selected option, it says `Free tier eligible` in green.
3.  Click on the `Edit security groups options` and setup the security group as below.
    Set the `source` on the SSH Type to `My IP`. This should automatically set the field to your IP address. This means you can only ssh into that instance from your computer.

    Click the `Add rule` button to add another rule. From the type drop down list, select `HTTP`. This will set the port to 80. This tells the instance to accept incoming HTTP traffic through port 80.

    Add another rule, from the dropdown, set the type to `Custom TCP Rule`, set the port to `8000`, This is added because gunicorn, exposes that port on the host and all appropriate traffic is routed through that port.

4.  At the bottom, click the blue `Review and Launch` button. On the next page, click, `Launch`. This will bring up a modal to add a key pair. A key pair consists of a public key that AWS stores, and a private key file that you store. Together, they allow you to connect to your instance securely.
5.  From the first drop down, select `create a new key pair`. Enter a name for your key pair, preferably one that includes the region name and the phrase key-pair at the end to allow you easily remember the region.
6.  Download the key pair and ensure to keep it well on your computer. For Linux AMIs, as is our case, the private key file allows you to securely SSH into your instance so take note of where it is downloaded to. Without the key-pair you will not be able to access any instance created with it.
7.  Click the `Launch Instance` button. On the next page, click on the `View Instances` button.
8.  Once the instance is now running, make sure the instance is selected via the checkbox with a blue dot. Click on the `Connect` button.
9.  It is a best practice to save your ssh key in the ssh folder (It is a hidden folder) on your computer so move it to there by running this bash command in your terminal.

    `mv <current location of the file>/<name-of-key-pair>.pem ~/.ssh/`

10. In your terminal, run the command given to you to change ensure that your key is not publicly viewable.
11. Copy the line right after `Example` that starts with ssh. Now still in your terminal, paste that line but adjust the path to the key pair file to be in your .ssh folder and run it.
12. You are now in the instance. Now clone this repo, cd into the directory and run the script using:

    `. cp3-setup.sh`

## REACT/REDUX AWS DEPLOYMENT AUTOMATION SCRIPT

### Instructions for CP4 deployment

To create an instance for this deployment. if you have not done the CP3 deployment before, follow the steps above till step 11 with adjustment to the Security group as instructed below.

If you have done so already, you will need to skip some of those steps as needed for example we have a key-pair already so we do not need to create another one.

Follow steps 1 - 2. Then create a security group as follows
<img width="1166" alt="screen shot 2018-05-12 at 07 28 32" src="https://user-images.githubusercontent.com/5388763/39953540-bc33a74a-55b6-11e8-983c-f97b71a3dfd2.png">

The first 2 rules are the same as those for the CP3 deployment. We then add a third rule for HTTPS which sets the port to 443.

Continue to step 3 and 4. At step 5 select `choose an existing key-pair`. Skip step 6 since you already have the key-pair. Follow steps 7, 8 and 11.

At step 12, run the script using

`. cp4-setup.sh`
