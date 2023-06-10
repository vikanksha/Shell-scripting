#!/bin/bash

echo "Installing nginx"

yum install nginx -y

# Let's download the HTDOCS content and deploy it under the Nginx path.

# ```
# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# ```

# Deploy in Nginx Default Location.

# ```
# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf

# ```

# - Finally, restart the service once to effect the changes.
# - Now, you should be able to access the ROBOSHOP e-commerce webpage as shown below