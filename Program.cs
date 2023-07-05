using Microsoft.Azure.Cosmos;

namespace HelloWorld
{
    class Program
    {
        static async Task Main(string[] args)
        {
            bool offline = true;
            string? endpoint; // ? makes the type nullable, default is non-nullable
            string? key;
            CosmosClient client;
            // We can change options to client as well
            CosmosClientOptions options =
                new()
                {
                    ConnectionMode = ConnectionMode.Direct, // can be Direct ot Gateway. Default is Direct. In Gatway, requests are routed through database gateway as proxy
                    ConsistencyLevel = ConsistencyLevel.Eventual, // to change consistency level, total 5 consistency levels. It is used to weaken read consistency.
                    ApplicationRegion = Regions.EastUS, // if multi-write is not enabled, it only for read operations
                    // ApplicationPreferredRegions = new List<string> { "westus", "eastus" }
                };
            if (offline == false)
            {
                Console.WriteLine($"Azure {offline}");
                endpoint = Environment.GetEnvironmentVariable("COSMOS_ENDPOINT");
                key = Environment.GetEnvironmentVariable("COSMOS_KEY");
                client = new(endpoint, key, options);
            }
            else
            {
             Console.WriteLine($"Emulator {offline}");
                endpoint = "https://localhost:8081/";
                key =
                    "C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==";
                client = new(endpoint, key);
            } // using  /Key new key also can be generated but by default this is static

            AccountProperties account = await client.ReadAccountAsync();
            Console.WriteLine($"Account Name:\t{account.Id}");
            Console.WriteLine($"Primary Region:\t{account.WritableRegions.FirstOrDefault()?.Name}");

            Database database = await client.CreateDatabaseIfNotExistsAsync("cosmicworks");
            // Database database = client.GetDatabase("cosmicworks"); # database exits then just to retrive it
            // Database database = await client.CreateDatabaseAsync("cosmicworks"); # If database does not exist and we have to create
            Container container = await database.CreateContainerIfNotExistsAsync(
                id: "products",
                partitionKeyPath: "/categoryId",
                throughput: 400
            ); // same database commands work for containers as well.
            Console.WriteLine($"New database:\t{database.Id}");
            Console.WriteLine($"New container:\t{container.Id}");
        }
    }
}
