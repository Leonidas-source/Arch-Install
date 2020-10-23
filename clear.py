import os
if os.path.exists("mnt/installarchp2.sh"):
    os.remove("mnt/installarchp2.sh")
else:
    print("error")
if os.path.exists("mnt/grubinstall.sh"):
    os.remove("mnt/grubinstall.sh")
else:
    print("error")
if os.path.exists("mnt/2"):
    os.remove("mnt/2")
else:
    print("error")
