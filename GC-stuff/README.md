# A command-line guide to setup preemptible GPUs with fastai1.0 library

## Prerequisites
1. A GCP account with valid billing details.
2. Quota of alteast 1 GPU alloted.

## Steps
1. git clone https://github.com/shang-vikas/fastai-v3stuff
2. cd fastai-v3stuff/GC-stuff
3. cat commands >> ~/.bashrc && source ~/.bashrc ##this will add necessary shorter version of gcloud commands
4. chmod +x ./script.sh  ##make the script executable
5. sudo ./script.sh  ## run the script

After step 5, you will have a gpu-instance with pre-installed fastai-library and its dependencies.An external disk has been attached to your instance at /ext.
You can clone the fastai-v3 course files there and start learning. Your data will be safe in case the instances stops.Just make sure you save your notebooks at regular intervals.
 The above steps should be performed once for one instance.<br>
 GCP deletes the pre-emptible VM after 24 hours, but your external disk where your main data is stored is pertained.<br>
So when you spin off another gpu-instance just dont create a new-disk, attach the existing one.<br>
**Further steps to get a running notebook in your local browser** <br>
6. GSSH <YOUR_INSTANCE_NAME_THAT_YOU_JUST_CREATED> <br>
7. Open your favorite browser and type 127.0.0.1:8080 and here's your notebook. <br>

**Additional steps to make life easier**
Run following commands in either notebook or terminal.
sudo ln -s /ext /home/jupyter
sudo chmod 777 ./ext

**Note**: To go root anytime, type sudo -s.

