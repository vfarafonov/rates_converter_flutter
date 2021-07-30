# Rates converter

Currency rates converter project. This project allows a user to get currency exchange rate for a pair of
currencies

Currency rates API: [exchangeratesapi.io](https://exchangeratesapi.io). FYI: `openrates.io` service is not available. 

Supported platforms: Android, iOS.

Notes:
- Currency Amount presented by Major units. That is not that flexible, but for the goals of this task I did not want
  to overcomplicate the code 
- Supported currencies are hard-coded and limited to some extent. Currency rates API have an endpoint to list all 
  supported currency, but the output is not complete as they miss currency character. In the future we can integrate
  and provide additional mapping for currency character.
- App downloads rates for all currencies at once. Those rates are uses the same base currency. App just computes cross
  rates using the base rate.
- Rates are cached for each app launch because I have a basic plan which is limited and contains only daily rates 
  updates. So having more frequent requests would not make a sense and will just delay conversion.  
- Did not have time for thousands separation, but really nice to have
- I wish to have more time to implement dependency inversion and tests
- That is possible to select the same currencies on both sides or select the same currency as active. For real app 
  I would probably improve UX
- Had no time for screen layout optimisation, but should not be an issue on most screens
