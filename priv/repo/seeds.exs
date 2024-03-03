# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FabricEx.Repo.insert!(%FabricEx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Add fabrics to users
FabricEx.Repo.insert!(%FabricEx.Fabric{
        image: "https://fabrics-store.com/images/product/FS_F_21621680281605_1000x1000.jpg",
        width: 58,
        color: "blue",
        shade: "medium",
        weight: "lightweight",
        content: "linen",
        structure: "woven",
        yards: 5,
        item_number: "IL020",
        user_id: 3
})

FabricEx.Repo.insert!(%FabricEx.Fabric{
        image: "https://fabrics-store.com/images/product/FS_F_1684933105_1000x1000.jpeg",
        width: 59,
        color: "brown",
        shade: "medium",
        weight: "midweight",
        content: "linen",
        structure: "woven",
        yards: 6,
        item_number: "IL019",
        user_id: 2
})
