## RDS/Database Mgmt
= pre-config'd instances of common relational db's (incl. Postgres)

you can't do joins in MongoDB (NoSQL)

For an undeployed app, can set global variable [`DATABASE_URL`](https://joaquimadraz.com/guide-to-deploy-an-elixir-phoenix-app-to-aws-ecs#setup-aws-ecs-cluster-ec2-and-rds) (or something like that) to your RDS. The app is hosted in EC2 (will come in a later lecture).

### Relational DB's
db = data structure stored on disk rather than in RAM

**[Where data is stored on disk](http://www.postgresql.fastware.com/blog/where-and-how-is-your-data-actually-stored-on-disk)**

(literally, just in files in a directory; records are separated by a newline, for example)

Redis = hashmap on disk

* data stored in tables (rows & col's)
* underlying data structure = BST or Array (fixed fields)
* queries (searching) typ via SQL
* primary key typ rep'd in disk (= key of BST)
* adding "indices" (BST keys) increase search speed

reading: O(log n) to O(n)

writing: O(log n) -- to update index of BST

sequential records accessed by primary key (then structured into BST)

Records are just entries of an array-like disk structure.

**[How Indexing Works](https://medium.com/omarelgabrys-blog/database-indexing-and-transactions-part-9-a24781d429f8)**

Normally, data is ordered by primary key. An index orders data by a selected column in a BST (with the primary key). The database can jump to that primary key in steps of record-length (assuming records are contiguous). An index makes reads closer to best-case, but adds a 2nd tree for writes (doubling time).

Composite index: "Now, the Index table will be sorted according to the first name, and for each value of the first name it will be sorted according to the last name."

### Read Replica
* Master uses transaction log shipping to update Slave
  * indices may vary btwn db's

[Master-Slave vs. Sharding](http://www.agildata.com/database-sharding/)

"The Master/Slave model can speed overall performance to a point, allowing read-intensive processing to be offloaded to the Slave servers, but there are several limitations with this approach:"

* The single Master server for writes is a clear limit to scalability, and can quickly create a bottleneck.
* The Master/Slave replication mechanism is “near-real-time,” meaning that the Slave servers are not guaranteed to have a current picture of the data that is in the Master. While this is fine for some applications, if your applications require an up-to-date view, this approach is unacceptable.
* Many organizations use the Master/Slave approach for high-availability as well, but it suffers from this same limitation given that the Slave servers are not necessarily current with the Master. If a catastrophic failure of the Master server occurs, any transactions that are pending for replication will be lost, a situation that is highly unacceptable for most business transaction applications.

"Database Sharding: The 'Shared Nothing' Approach"

**[Horizontal vs. Vertical Sharding](https://medium.com/@jeeyoungk/how-sharding-works-b4dec46b3f6)**
"A database can be split vertically — storing different tables & columns in a separate database, or horizontally — storing rows of a same table in multiple database nodes."

"Vertical partitioning is very domain specific. You draw a logical split within your application data, storing them in different databases. It is almost always implemented at the application level — a piece of code routing reads and writes to a designated database.

In contrast, sharding splits a homogeneous type of data into multiple databases. You can see that such an algorithm is easily generalizable. That’s why sharding can be implemented at either the application or database level... Almost all modern databases are natively sharded. Cassandra, HBase, HDFS, and MongoDB are popular distributed databases. Notable examples of non-sharded modern databases are Sqlite, Redis (spec in progress), Memcached, and Zookeeper."

### Backups (Snapshots) of DB Data
via AWS UI or,

```
pg_dump --host=<host1> <dbname1> > latest.dump
pg_restore --host=<host2> --dbname=<dbname2> latest.dump
```
