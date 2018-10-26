# A command-line guide to setup preemptible GPUs with fastai1.0 library

## Prerequisites
1. A GCP account with valid billing details.
2. Quota of alteast 1 GPU alloted.

## Steps for first-time
1. `git clone https://github.com/shang-vikas/fastai-v3stuff`
2. `cd fastai-v3stuff/GC-stuff`
3. `chmod +x ./run_this_first_time`  ##make the script executable
4. `sudo ./run_this_first_time`  ## run the script

After following the steps in script, you will have a gpu-instance with pre-installed fastai-library and its dependencies.An external disk would be attached to your instance at /ext if you opted for that.
The fastai-v3 course files will be present in tutorials/fastai. I recommend you move them to ext. Your data will be safe for both external and internal storage in case the instances stops.Just make sure you save your notebooks at regular intervals.
 The above steps should be performed once for one instance.<br>
 GCP deletes the pre-emptible VM after 24 hours, but your external disk where your main data is stored will be there for default according to default settings.You need to delete it manually.<br>
So when you spin off another gpu-instance/cpu-instance just dont create a new external disk, attach the existing one.<br>
**Further steps to get a running notebook in your local browser** <br>
6. `GSSH <YOUR_INSTANCE_NAME_THAT_YOU_JUST_CREATED>` <br>
7. Open your favorite browser and type `127.0.0.1:8080` and here's your notebook. <br>

## Steps to launch a cpu/gpu instance.
Just run `gcreate_cpu/gcreate_gpu`.

## Steps to switch between cpu and gpu.
Run `gswh_tocpu $cpu_instance_name` # This will stop the current gpu_instance, detach the external disk and attach that to cpu_instance_name given. Note that id $cpu_instance_name is not found, the system will automatically create a cpu instance with default settings(n1-higmem-8).<br>
Run `gswh_togpu $gpu_instance_name` # This will stop the current cpu_instance, detach the external disk and attach that to gpu_instance_name given. Note that if $gpu_instance_name is not found, the system will automatically create a gpu instance with default settings(n1-highmem-8,k80-1).


**Note**: To go root anytime, type `sudo -s`.

### TO-DOs
- [ ] - Add jupyter-widget and sound notification during shutdown-signal
