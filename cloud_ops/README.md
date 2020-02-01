# README

* Mongodb Database

* Uses whenever for scheduling the job

* Services (Sidekiq)

* Used shoulda-matchers for Rspec match


# Direct call of worker with sidkiq to create data

* AwsDataFetchWorker.perform_async

#API
Fetching all  data
*  GET http://localhost:3000/view_pricing
- Sample Response

[

    {
        "description": "$6.0E-7  per Request for Lambda-Edge-Request in EU (Paris)",
        "beginRange": "0",
        "endRange": "Inf",
        "unit": "Request",
        "pricePerUnit": "0.0000006000",
        "effectiveDate": "2019-12-01T00:00:00Z"
    },
    {
        "description": "$0.0100 per 10,000 HTTPS Requests",
        "beginRange": "0",
        "endRange": "Inf",
        "unit": "Requests",
        "pricePerUnit": "0.0000010000",
        "effectiveDate": "2019-12-01T00:00:00Z"
    }
    
]

# Example For  Filters Api

beginRange,
endRange,
pricePerUnit,
effectiveDate

* http://localhost:3000/view_pricing?endRange=Inf
* http://localhost:3000/view_pricing?beginRange=51200&endRange=153600   

* Sample Output

[

    {
        "description": "$6.0E-7  per Request for Lambda-Edge-Request in EU (Paris)",
        "beginRange": "0",
        "endRange": "Inf",
        "unit": "Request",
        "pricePerUnit": "0.0000006000",
        "effectiveDate": "2019-12-01T00:00:00Z"
    }
    
]




