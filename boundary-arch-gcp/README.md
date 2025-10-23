#
In This GCP boundary arch
We will try to deplloy the boudary arch to build secure and efficient connection to VM's in private subnet
These VM's does'nt have external IP's and public firewall they are connected to Google IAP + boundary + Vault so that we don't have to share the VM ssh keys and no need to create seperate Google account in GCP so improve the connectivity to other users also


          +----------------+
          |    network     |
          +----------------+
                   |
        +----------+-----------+
        |                      |
 +-------------+       +--------------+
 |    consul   |       |     iap      |
 +-------------+       +--------------+
        |                      |
        |                +-----------+
 +-------------+         | controller|
 |    vault    |-------->|  (public) |
 +-------------+         +-----------+
        |                      |
        |                      v
        |                +-----------+
        +--------------->|  worker   |
                         | (private) |
                         +-----------+
                               |
                               v
                         +-----------+
                         |   vms     |
                         +-----------+
