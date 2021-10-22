# Arch-Install
1) Check your ethernet connection by pinging google website
![image](https://user-images.githubusercontent.com/66934329/114667785-1d423e80-9d2a-11eb-97d3-392b67db6bee.png)
2) Install git
![image](https://user-images.githubusercontent.com/66934329/114667943-4e227380-9d2a-11eb-91a3-17cb15ad6c9b.png)
![image](https://user-images.githubusercontent.com/66934329/114668040-74e0aa00-9d2a-11eb-9184-8f34cfd26aad.png)
3) Clone my repository
![image](https://user-images.githubusercontent.com/66934329/114668161-9a6db380-9d2a-11eb-8d55-1ca55f29a4e8.png)
4) Execute install.sh
![image](https://user-images.githubusercontent.com/66934329/114668263-bb360900-9d2a-11eb-8ddb-291da6dc7699.png)
5) Here you can remove your bootloader well you know just in case
![image](https://user-images.githubusercontent.com/66934329/114668315-cab55200-9d2a-11eb-8232-53f2a5caabf2.png)
6) Here you can delete everething from your disk
![image](https://user-images.githubusercontent.com/66934329/114668374-dbfe5e80-9d2a-11eb-96ea-e645e1d71838.png)
![image](https://user-images.githubusercontent.com/66934329/114668421-e91b4d80-9d2a-11eb-865d-01318a4b8e33.png)
7) Ok, we need to set up disk where / would be 
![image](https://user-images.githubusercontent.com/66934329/114668449-f2a4b580-9d2a-11eb-9d9f-0d0ecc1a43f0.png)
8) Next step partition table(i recommend GPT for UEFI installation and MBR for BIOS installation)
![image](https://user-images.githubusercontent.com/66934329/114668497-051eef00-9d2b-11eb-8099-6da69ae5cf24.png)
9) On gpt we need at least 2 partitions (EFI partition, partition for /)
![image](https://user-images.githubusercontent.com/66934329/114668580-1d8f0980-9d2b-11eb-886b-a80e7f00f098.png)
10) Here you can set up another disk if you need that
![image](https://user-images.githubusercontent.com/66934329/114668635-28499e80-9d2b-11eb-8e53-662b8dd31072.png)
11) Here set your system type 
![image](https://user-images.githubusercontent.com/66934329/114668678-33043380-9d2b-11eb-86e3-2d29bcb506bf.png)
12) Here you need to set your EFI partition)
![image](https://user-images.githubusercontent.com/66934329/114668750-49aa8a80-9d2b-11eb-8dd4-0930e610d85a.png)
13) If you want to format EFI partition press 1 and Enter
![image](https://user-images.githubusercontent.com/66934329/114668778-53cc8900-9d2b-11eb-8474-af7780b81554.png)
14) For better compatibility you should choose fat32, but if you don't want to use bootloader and you prefer EFISTUB you can choose exfat 
![image](https://user-images.githubusercontent.com/66934329/114668828-6050e180-9d2b-11eb-8ea2-0b2002c3da5a.png)
15) Ok, here you need to set your partition for / mount point
![image](https://user-images.githubusercontent.com/66934329/114668869-6e9efd80-9d2b-11eb-81b6-ff4d4bdd84f1.png)
![image](https://user-images.githubusercontent.com/66934329/114668941-88404500-9d2b-11eb-8180-315f83e3e924.png)
16) Here you can encypt your / partition
![image](https://user-images.githubusercontent.com/66934329/114668967-91311680-9d2b-11eb-81a3-b4c603812cd3.png)
17) Here you can choose your filesystem for /
![image](https://user-images.githubusercontent.com/66934329/114669080-b3c32f80-9d2b-11eb-85a2-cf67ed94b8b0.png)
18) Because i choosed btrfs option, now i can choose compression which btrfs filesystem support 
![image](https://user-images.githubusercontent.com/66934329/114669117-be7dc480-9d2b-11eb-9d28-54f97226360d.png)
![image](https://user-images.githubusercontent.com/66934329/114669164-ca698680-9d2b-11eb-90fd-63958334ee79.png)
19) Here you can define swap partition
![image](https://user-images.githubusercontent.com/66934329/114669218-d5241b80-9d2b-11eb-96df-4955ae0ad22e.png)
20) Here you can set up /home mount point
![image](https://user-images.githubusercontent.com/66934329/114669253-df461a00-9d2b-11eb-912f-dc9ac243150c.png)
21) After that you'll see black screen for 5-10 minutes or less because of optimal mirror search 
![image](https://user-images.githubusercontent.com/66934329/114669288-ea00af00-9d2b-11eb-9fd0-b5ea69f0d598.png)
22) Here you can set your favorite kernel
![image](https://user-images.githubusercontent.com/66934329/114670507-444e3f80-9d2d-11eb-81c2-07c2666e550b.png)
23) And now it's installing base system
![image](https://user-images.githubusercontent.com/66934329/114670546-516b2e80-9d2d-11eb-9f48-79fe69a574f8.png)
24) Now you have to define your locale in nano(to navigate use arrows).
![image](https://user-images.githubusercontent.com/66934329/114670959-bcb50080-9d2d-11eb-872f-20d4f6284434.png)
![image](https://user-images.githubusercontent.com/66934329/114671010-d0f8fd80-9d2d-11eb-8e8a-26b281a42017.png)
25) To save use F3 and to exit use F2
![image](https://user-images.githubusercontent.com/66934329/114671072-e2420a00-9d2d-11eb-8494-b727f945ac7b.png)
![image](https://user-images.githubusercontent.com/66934329/114671136-f2f28000-9d2d-11eb-9c48-32aa09402bce.png)
26) Here you can set up your host name
![image](https://user-images.githubusercontent.com/66934329/114671187-00a80580-9d2e-11eb-8d2e-665876a0069a.png)
27) Here you can set up your root password
![image](https://user-images.githubusercontent.com/66934329/114671221-0bfb3100-9d2e-11eb-9e99-609953f8054f.png)
![image](https://user-images.githubusercontent.com/66934329/114671270-19182000-9d2e-11eb-82a3-ad15778ff263.png)
28) Here you can set up your user
![image](https://user-images.githubusercontent.com/66934329/114671303-23d2b500-9d2e-11eb-98f8-8c8f21c3b221.png)
![image](https://user-images.githubusercontent.com/66934329/114671345-30efa400-9d2e-11eb-8cbf-bc11ba160cb1.png)
29) Here you can set up password for your user
![image](https://user-images.githubusercontent.com/66934329/114671385-3fd65680-9d2e-11eb-90a4-abc1a2a6914a.png)
30) Here you can enable ethernet
![image](https://user-images.githubusercontent.com/66934329/114671431-4d8bdc00-9d2e-11eb-9e4f-6fe8237fb88d.png)
31) Here you can choose programm that allows a system administrator to delegate authority to give certain users—or groups of users
![image](https://user-images.githubusercontent.com/66934329/114671483-58df0780-9d2e-11eb-93a7-953f0b724701.png)
![image](https://user-images.githubusercontent.com/66934329/114671515-62686f80-9d2e-11eb-85cc-a316d053f3ab.png)
32) Here you can choose to install desktop environment
![image](https://user-images.githubusercontent.com/66934329/114671561-6e543180-9d2e-11eb-9df4-552b2714ea9c.png)
33) Here you can choose particular desktop environment
![image](https://user-images.githubusercontent.com/66934329/114671612-7a3ff380-9d2e-11eb-9856-85f9016e8ac7.png)
![image](https://user-images.githubusercontent.com/66934329/114671671-8926a600-9d2e-11eb-8ade-1296cf884675.png)
34) Here you can install packages by typing their names(After choose menu)
![image](https://user-images.githubusercontent.com/66934329/114671861-c12de900-9d2e-11eb-8f29-393030b5e965.png)
35) Here you can install bootloader 
![image](https://user-images.githubusercontent.com/66934329/114671921-cdb24180-9d2e-11eb-8520-93cc80a41279.png)
36) Set your / partition
![image](https://user-images.githubusercontent.com/66934329/114671985-db67c700-9d2e-11eb-9717-45bd7062055d.png)
37) That's it. Now you can enjoy your system
![image](https://user-images.githubusercontent.com/66934329/114672091-f33f4b00-9d2e-11eb-8b84-c0ac30ad7476.png)
![image](https://user-images.githubusercontent.com/66934329/114672171-08b47500-9d2f-11eb-8c8f-737dd885c9cc.png)
![image](https://user-images.githubusercontent.com/66934329/114672212-1669fa80-9d2f-11eb-9e11-8362011fff0b.png)
![image](https://user-images.githubusercontent.com/66934329/114672332-3ac5d700-9d2f-11eb-8fd4-4747574da5d8.png)
