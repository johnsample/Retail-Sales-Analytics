import pandas as pd

# ============================================================
# 1. LOAD DATASET
# ============================================================

file_path = "Retail_Sales_Cleaned_For_PostgreSQL.csv"

df = pd.read_csv(file_path)

print("\n========== DATASET OVERVIEW ==========")
print("Rows and Columns:", df.shape)

print("\nFirst 5 Rows:")
print(df.head())


# ============================================================
# 2. DATA INFORMATION
# ============================================================

print("\n========== DATA INFORMATION ==========")
df.info()

print("\nMissing Values:")
print(df.isnull().sum())


# ============================================================
# 3. KEY PERFORMANCE INDICATORS (KPIs)
# ============================================================

total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()
total_quantity = df["Quantity"].sum()
total_orders = df["Order_ID"].nunique()

profit_margin = (total_profit / total_sales) * 100

print("\n========== KEY PERFORMANCE INDICATORS ==========")
print(f"Total Sales: ₹{total_sales:,.2f}")
print(f"Total Profit: ₹{total_profit:,.2f}")
print(f"Total Quantity: {total_quantity:,.0f}")
print(f"Total Orders: {total_orders:,}")
print(f"Overall Profit Margin: {profit_margin:.2f}%")


# ============================================================
# 4. SALES AND PROFIT BY CATEGORY
# ============================================================

category_analysis = (
    df.groupby("Category")[["Sales", "Profit"]]
    .sum()
    .sort_values("Sales", ascending=False)
)

print("\n========== SALES & PROFIT BY CATEGORY ==========")
print(category_analysis)


# ============================================================
# 5. PROFIT MARGIN BY CATEGORY
# ============================================================

category_margin = (
    df.groupby("Category")[["Sales", "Profit"]]
    .sum()
)

category_margin["Profit_Margin_%"] = (
    category_margin["Profit"] /
    category_margin["Sales"] * 100
)

category_margin = category_margin.sort_values(
    "Profit_Margin_%",
    ascending=False
)

print("\n========== PROFIT MARGIN BY CATEGORY ==========")
print(category_margin)


# ============================================================
# 6. SALES BY CITY
# ============================================================

city_analysis = (
    df.groupby("City")["Sales"]
    .sum()
    .sort_values(ascending=False)
)

print("\n========== SALES BY CITY ==========")
print(city_analysis)

print("\nTop 5 Cities by Sales:")
print(city_analysis.head(5))


# ============================================================
# 7. SALES BY CUSTOMER SEGMENT
# ============================================================

segment_analysis = (
    df.groupby("Segment")["Sales"]
    .sum()
    .sort_values(ascending=False)
)

print("\n========== SALES BY CUSTOMER SEGMENT ==========")
print(segment_analysis)


# ============================================================
# 8. SALES BY PAYMENT MODE
# ============================================================

payment_analysis = (
    df.groupby("Payment_Mode")["Sales"]
    .sum()
    .sort_values(ascending=False)
)

print("\n========== SALES BY PAYMENT MODE ==========")
print(payment_analysis)


# ============================================================
# 9. MONTHLY SALES TREND
# ============================================================

# Convert Order_Date from text to datetime
df["Order_Date"] = pd.to_datetime(
    df["Order_Date"],
    dayfirst=True,
    errors="coerce"
)

monthly_sales = (
    df.groupby(df["Order_Date"].dt.to_period("M"))["Sales"]
    .sum()
)

print("\n========== MONTHLY SALES TREND ==========")
print(monthly_sales)


# ============================================================
# 10. TOP 10 PRODUCTS BY SALES
# ============================================================

top_products = (
    df.groupby("Product")[["Sales", "Profit"]]
    .sum()
    .sort_values("Sales", ascending=False)
    .head(10)
)

print("\n========== TOP 10 PRODUCTS BY SALES ==========")
print(top_products)


# ============================================================
# 11. SALES BY REGION
# ============================================================

region_analysis = (
    df.groupby("Region")[["Sales", "Profit"]]
    .sum()
    .sort_values("Sales", ascending=False)
)

print("\n========== SALES & PROFIT BY REGION ==========")
print(region_analysis)


# ============================================================
# 12. DISCOUNT VS PROFITABILITY
# ============================================================

def discount_category(discount):
    if discount < 0.10:
        return "Low Discount"
    elif discount <= 0.20:
        return "Medium Discount"
    else:
        return "High Discount"


df["Discount_Category"] = df["Discount"].apply(discount_category)

discount_analysis = (
    df.groupby("Discount_Category")[["Sales", "Profit"]]
    .sum()
)

discount_analysis["Profit_Margin_%"] = (
    discount_analysis["Profit"] /
    discount_analysis["Sales"] * 100
)

print("\n========== DISCOUNT VS PROFITABILITY ==========")
print(discount_analysis)


# ============================================================
# 13. FINAL SUMMARY
# ============================================================

print("\n========== FINAL PROJECT SUMMARY ==========")

highest_sales_category = category_analysis["Sales"].idxmax()
highest_profit_category = category_analysis["Profit"].idxmax()
highest_margin_category = category_margin["Profit_Margin_%"].idxmax()
highest_sales_city = city_analysis.idxmax()
highest_sales_segment = segment_analysis.idxmax()
highest_payment_mode = payment_analysis.idxmax()

print(f"Highest Sales Category: {highest_sales_category}")
print(f"Highest Profit Category: {highest_profit_category}")
print(f"Highest Profit Margin Category: {highest_margin_category}")
print(f"Highest Sales City: {highest_sales_city}")
print(f"Highest Sales Segment: {highest_sales_segment}")
print(f"Most Used Payment Mode by Sales: {highest_payment_mode}")

print("\n========== ANALYSIS COMPLETED ==========")