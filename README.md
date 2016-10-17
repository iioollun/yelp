### Basic Yelp client

This is a headless example of how to implement an OAuth 1.0a Yelp API client. The Yelp API provides an application token that allows applications to make unauthenticated requests to their search API.

### Next steps

- Check out `BusinessesViewController.swift` to see how to use the `Business` model.

### Sample request

**Basic search with query**

```
Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
    if let businesses = businesses {
        self.businesses = businesses

        for business in businesses {
            print(business.name!)
            print(business.address!)
        }
    }
}
```

**Advanced search with categories, sort, and deal filters**

```
Business.search(with: "Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]?, error: Error?) in
    if let businesses = businesses {
        self.businesses = businesses

        for business in businesses {
            print(business.name!)
            print(business.address!)
        }
    }
}
```
