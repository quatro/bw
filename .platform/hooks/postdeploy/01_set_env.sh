#!/bin/bash

# see:  https://aws.amazon.com/premiumsupport/knowledge-center/elastic-beanstalk-env-variables-linux2/

#Note:
# If you change this file, you should probably also change the one in 
# .platform/confighooks

#Create a copy of the environment variable file.
cp /opt/elasticbeanstalk/deployment/env /opt/elasticbeanstalk/deployment/booking_env_temp

#prepend "export " to each line so that we have:
#export k1=v1
#export k2=v2
#and so on.

(sed -E -n 's/[^#]+/export &/ p' /opt/elasticbeanstalk/deployment/booking_env_temp) > /opt/elasticbeanstalk/deployment/booking_env

#Set permissions to the custom_env_var file so this file can be accessed by any user on the instance. You can restrict permissions as per your requirements.
chmod 644 /opt/elasticbeanstalk/deployment/booking_env

#Remove duplicate files upon deployment.
rm -f /opt/elasticbeanstalk/deployment/booking_env_temp
