#!/usr/bin/env bash
mkdir replication
touch state.yaml
echo "state_file: state.yaml" > config.yaml
echo "db: host=$POSTGRES_HOST dbname=$POSTGRES_DB user=$POSTGRES_USER password=$POSTGRES_PASSWORD" >> config.yaml
echo "data_dir: replication/" >>  config.yaml
./replicate_changesets.rb config.yaml

# # OSMOSIS tuning: https://wiki.openstreetmap.org/wiki/Osmosis/Tuning,https://lists.openstreetmap.org/pipermail/talk/2012-October/064771.html
# if [ -z "$MEMORY_JAVACMD_OPTIONS" ]; then
#     echo JAVACMD_OPTIONS=\"-server\" > ~/.osmosis
# else
#     memory="${MEMORY_JAVACMD_OPTIONS//i}"
#     echo JAVACMD_OPTIONS=\"-server -Xmx$memory\" > ~/.osmosis
# fi

# workingDirectory="data"

# if [ $STORAGE == "GS" ]; then
#     # Creating a gcloud-service-key to authenticate the gcloud
#     echo $GCLOUD_SERVICE_KEY | base64 --decode --ignore-garbage > gcloud-service-key.json
#     /root/google-cloud-sdk/bin/gcloud --quiet components update
#     /root/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file gcloud-service-key.json
#     /root/google-cloud-sdk/bin/gcloud config set project $GCLOUD_PROJECT
# fi

# # Check if state.txt exist in the workingDirectory,
# # in case the file does not exist locally and does not exist in the cloud the replication will start from 0
# if [ ! -f $workingDirectory/state.txt ]; then
#     echo "File $workingDirectory/state.txt does not exist"
#     echo "let's get check the cloud"
#     if [ $STORAGE == "S3" ]; then 
#         aws s3 ls $S3_OSM_PATH$CHANGESET_FOLDER/state.txt
#         if [[ $? -eq 0 ]]; then
#             echo "File exist, let's get it"
#             aws s3 cp $S3_OSM_PATH$CHANGESET_FOLDER/state.txt $workingDirectory/state.txt
#         fi
#     fi
#     if [ $STORAGE == "GS" ]; then
#         gsutil ls $GS_OSM_PATH$CHANGESET_FOLDER/state.txt
#         if [[ $? -eq 0 ]]; then
#             echo "File exist, let's get it"
#             gsutil cp $GS_OSM_PATH$CHANGESET_FOLDER/state.txt $workingDirectory/state.txt
#         fi
#     fi
# fi
# # Creating the replication file

# osmosis \
# --read-apidb-change \
# host=$POSTGRES_HOST \
# database=$POSTGRES_DB \
# user=$POSTGRES_USER \
# password=$POSTGRES_PASSWORD \
# validateSchemaVersion=no \
# --write-xml-change \
# workingDirectory=data 




# osmosis --read-xml-change \
# host=$POSTGRES_HOST \
# database=$POSTGRES_DB \
# user=$POSTGRES_USER \
# password=$POSTGRES_PASSWORD \
# validateSchemaVersion=no \
# workingDirectory=data 



 



# osmosis -q \
# --read-apidb-change \
# host=$POSTGRES_HOST \
# database=$POSTGRES_DB \
# user=$POSTGRES_USER \
# password=$POSTGRES_PASSWORD \
# validateSchemaVersion=no \
# --write-replication \
# workingDirectory=$workingDirectory &
# while true
# do 
#     echo "Sync bucket at ..." $S3_OSM_PATH$CHANGESET_FOLDER $(date +%F_%H-%M-%S)
#     # AWS
#     if [ $STORAGE == "S3" ]; then 
#         # Sync to S3
#         aws s3 sync $workingDirectory $S3_OSM_PATH$CHANGESET_FOLDER
#     fi

#     # Google Storage
#     if [ $STORAGE == "GS" ]; then
#         # Sync to GS, Need to test,if the files do not exist  in the folder it will remove into the bucket too.
#         gsutil rsync -r $workingDirectory $GS_OSM_PATH$CHANGESET_FOLDER
#     fi
#     sleep 1m
# done