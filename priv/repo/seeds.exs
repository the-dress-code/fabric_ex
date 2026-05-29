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

alias FabricEx.Accounts
alias FabricEx.Repo
alias FabricEx.Fabrics.Fabric

# A known test login for local development and browser QA.
# Idempotent: re-running seeds won't fail if the user already exists.
test_email = "test@example.com"

test_user =
  Accounts.get_user_by_email(test_email) ||
    case Accounts.register_user(%{email: test_email, password: "password123456"}) do
      {:ok, user} -> user
      {:error, changeset} -> raise "Failed to seed test user: #{inspect(changeset.errors)}"
    end

# Add fabrics to the seeded test user
Repo.insert!(%Fabric{
  image: "https://fabrics-store.com/images/product/FS_F_21621680281605_1000x1000.jpg",
  width: 58,
  color: "blue",
  shade: "medium",
  weight: "lightweight",
  content: "linen",
  structure: "woven",
  yards: 5.0,
  item_number: "IL020",
  user_id: test_user.id
})

Repo.insert!(%Fabric{
  image: "https://fabrics-store.com/images/product/FS_F_1684933105_1000x1000.jpeg",
  width: 59,
  color: "brown",
  shade: "medium",
  weight: "midweight",
  content: "linen",
  structure: "woven",
  yards: 6.0,
  item_number: "IL019",
  user_id: test_user.id
})
