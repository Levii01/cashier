# Cashier App

This is a simple Ruby checkout system I built to handle a small chain of supermarkets.  
The idea was to simulate a real cashier, including promotions, discounts, and tracking everything the customer does.

---

## Requirements

- Ruby **3.4.5** (this project was developed and tested on this version)
- Bundler (for managing gems)

---

## How it works

- You can **scan products** and they go into a basket.
- Each product has a price (stored as integer pennies, so no floating point weirdness).
- The checkout applies **promotions** automatically, like:
  - Buy One Get One Free (BOGOF) for Green Tea.
  - Bulk discount for strawberries (buy 3 or more → cheaper price per item).
  - Bulk percentage discount for coffee (buy 3 or more → each coffee is 2/3 of original price).

The system is smart enough to handle multiple promotions for the same product and always gives the **best deal** to the customer.

---

## Event Tracking

Everything that happens in the checkout is logged as an **Event**:

- Product scanned
- Discount applied
- Checkout calculated

All events are saved in memory and also written to log files in `log/`.  
There’s a separate log for each environment (`development`, `test`) and by date:

```

log/development_2025-09-04.log
log/test_2025-09-04.log

````

This lets you see exactly what happened during a checkout session.

---

## Installation

Clone the repo and install dependencies:

```bash
git clone https://github.com/yourusername/cashier.git
cd cashier
bundle install
````

---

## Usage

The easiest way to play with the app is to run an interactive Ruby shell with the project loaded:

```bash
irb -r './base.rb'
```

Then you can do:

```ruby
co = Checkout.new(PRICING_RULES)

co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
5.times { co.scan(PRODUCTS['SR1'])}
8.times { co.scan(PRODUCTS['CF1'])}

co.calculete_total
```

Output:

```
Subtotal: £130.39
Discount: £38.67
Total:    £91.72
```

---

## Testing

This project uses **RSpec**. Tests cover:

* Basket and BasketItem behavior
* Checkout calculations
* All promotion rules
* Event tracking

Run tests with:

```bash
bundle exec rspec
```

Integration tests are included to make sure multiple promotions on the same product always apply the **best discount**.

---

## Notes

* Prices are in **pennies** to avoid floating-point rounding errors.
* The code uses **TDD** and keeps things modular.
* Event logs give you a full history, so you can even debug or replay sessions if needed.
