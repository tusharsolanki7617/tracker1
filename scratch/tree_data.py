import json

# Define the tree structure for all screens
# Format: {"name": "WidgetName", "children": [...]}

PAGES = [
    {
        "num": 1,
        "title": "1. Login Screen",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Center",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "Text (Welcome Back)"},
                            {"name": "Text (Subtitle)"},
                            {"name": "TextField (Email)"},
                            {"name": "TextField (Password)"},
                            {"name": "ElevatedButton (Log In)"},
                            {
                                "name": "Row",
                                "children": [
                                    {"name": "Text"},
                                    {"name": "TextButton (Create Account)"}
                                ]
                            }
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 2,
        "title": "2. Create Account Screen",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Center",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "Text (Create Account)"},
                            {"name": "Text (Subtitle)"},
                            {"name": "TextField (Full Name)"},
                            {"name": "TextField (Email)"},
                            {"name": "TextField (Password)"},
                            {"name": "TextField (Confirm Password)"},
                            {"name": "ElevatedButton (Create Account)"},
                            {
                                "name": "Row",
                                "children": [
                                    {"name": "Text"},
                                    {"name": "TextButton (Log In)"}
                                ]
                            }
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 3,
        "title": "3. Dashboard Overview",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "Container (Net Balance)"},
                        {
                            "name": "Row",
                            "children": [
                                {"name": "Container (Income)"},
                                {"name": "Container (Expenses)"}
                            ]
                        },
                        {"name": "Text (Recent Activity)"},
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile"}
                            ]
                        },
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 4,
        "title": "4. All Transactions",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "Text (All Transactions)"},
                        {
                            "name": "ListView",
                            "children": [{
                                "name": "ListTile",
                                "children": [
                                    {"name": "Icon"},
                                    {"name": "Text (Title)"},
                                    {"name": "Text (Category)"},
                                    {"name": "Text (Date)"},
                                    {"name": "Text (Amount)"}
                                ]
                            }]
                        },
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 5,
        "title": "5. Menu / Screen List",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {
                            "name": "Drawer / Menu",
                            "children": [
                                {"name": "User Avatar"},
                                {"name": "Text (User)"},
                                {"name": "Text (Email)"}
                            ]
                        },
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile (Dashboard)"},
                                {"name": "ListTile (Transactions)"},
                                {"name": "ListTile (Categories)"},
                                {"name": "ListTile (Budget)"},
                                {"name": "ListTile (Settings)"}
                            ]
                        }
                    ]
                }]
            }]
        }
    },
    {
        "num": 6,
        "title": "6. Categories Breakdown",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "Text (Expense Categories)"},
                        {
                            "name": "Row",
                            "children": [
                                {"name": "Text (Breakdown)"},
                                {"name": "TextButton (Add)"}
                            ]
                        },
                        {"name": "Text (Total Expenses)"},
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile (Food)"},
                                {"name": "ListTile (Transport)"},
                                {"name": "ListTile (Bills)"},
                                {"name": "ListTile (Shopping)"}
                            ]
                        },
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 7,
        "title": "7. Monthly Budget",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "Text (Monthly Budget Tracker)"},
                        {"name": "Container (Budget Limit)"},
                        {"name": "Container (Total Spent)"},
                        {"name": "Container (Remaining)"},
                        {"name": "TextField (Update Budget Limit)"},
                        {"name": "ElevatedButton (Update)"},
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 8,
        "title": "8. Log Expense",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {"name": "Text (Log New Expense)"},
                            {"name": "TextField (Expense Title)"},
                            {"name": "TextField (Expense Amount)"},
                            {"name": "DropdownButton (Category)"},
                            {"name": "DatePicker (Date)"},
                            {"name": "ElevatedButton (Save Expense)"},
                            {"name": "TextButton (Change Date)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 9,
        "title": "9. Add Salary / Income",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {"name": "Text (Add Income / Salary)"},
                            {"name": "TextField (Income Source Title)"},
                            {"name": "TextField (Salary / Income Amount)"},
                            {"name": "DropdownButton (Income Category)"},
                            {"name": "DatePicker (Date)"},
                            {"name": "ElevatedButton (Save Income)"},
                            {"name": "TextButton (Change Date)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 10,
        "title": "10. Search",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "TextField (Search)"},
                        {"name": "Text (Matching Transactions)"},
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile (Dinner)"},
                                {"name": "ListTile (Mall)"},
                                {"name": "ListTile (Bus)"},
                                {"name": "ListTile (Salary)"}
                            ]
                        },
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 11,
        "title": "11. Currency Settings",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "Text (Currency Settings)"},
                        {"name": "Text (Select Currency)"},
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "RadioListTile (\$ US Dollar)"},
                                {"name": "RadioListTile (₹ Indian Rupee)"},
                                {"name": "RadioListTile (€ Euro)"},
                                {"name": "RadioListTile (£ Pound)"},
                                {"name": "RadioListTile (¥ Yen)"}
                            ]
                        },
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 12,
        "title": "12. Profile & Settings",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {
                                "name": "Container (Profile)",
                                "children": [
                                    {"name": "CircleAvatar"},
                                    {"name": "Text (User)"},
                                    {"name": "Text (Email)"}
                                ]
                            },
                            {"name": "Button (Edit Profile & Goals)"},
                            {"name": "Container (Salary Target)"},
                            {"name": "Container (Account Summary)"},
                            {"name": "Button (Log Out)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 13,
        "title": "13. Subscriptions",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {
                            "name": "Container (Monthly Cost)",
                            "children": [
                                {"name": "Text (Active)"},
                                {"name": "Text (Paused)"}
                            ]
                        },
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile (Netflix)"},
                                {"name": "ListTile (Spotify)"},
                                {"name": "ListTile (iCloud)"},
                                {"name": "ListTile (Amazon Prime)"},
                                {"name": "ListTile (Microsoft 365)"}
                            ]
                        },
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 14,
        "title": "14. Bill Reminders",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {
                            "name": "Container (Monthly Total)",
                            "children": [
                                {"name": "Text (Paid)"},
                                {"name": "Text (Remaining)"}
                            ]
                        },
                        {"name": "Text (Overdue)"},
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile (Internet)"},
                                {"name": "ListTile (Electricity)"},
                                {"name": "ListTile (Gym Membership)"}
                            ]
                        },
                        {"name": "FloatingActionButton (Add Bill)"},
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 15,
        "title": "15. Loan Tracker",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "Container (You Lent)"},
                        {"name": "Container (You Owe)"},
                        {"name": "Container (Net)"},
                        {"name": "Switch (Show Settled)"},
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile (John)"},
                                {"name": "ListTile (Sara)"},
                                {"name": "ListTile (Bank)"}
                            ]
                        },
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 16,
        "title": "16. Notes & Memos",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {"name": "AppBar"},
                        {"name": "TextField (Search Notes)"},
                        {
                            "name": "ListView",
                            "children": [
                                {"name": "ListTile (Monthly Budget Plan)"},
                                {"name": "ListTile (Saving Tips)"},
                                {"name": "ListTile (Investment Ideas)"}
                            ]
                        },
                        {"name": "FloatingActionButton (New Note)"},
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 17,
        "title": "17. Dashboard Navigation",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {
                            "name": "Body",
                            "children": [
                                {"name": "Dashboard Screen"}
                            ]
                        },
                        {
                            "name": "BottomNavigationBar",
                            "children": [
                                {"name": "Icon (Dashboard)"},
                                {"name": "Icon (Salary)"},
                                {"name": "Icon (Expense)"},
                                {"name": "Icon (Search)"},
                                {"name": "Icon (Profile)"}
                            ]
                        }
                    ]
                }]
            }]
        }
    },
    {
        "num": 18,
        "title": "18. Salary Navigation",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {
                            "name": "Body",
                            "children": [
                                {"name": "Add Salary / Income"}
                            ]
                        },
                        {
                            "name": "BottomNavigationBar",
                            "children": [
                                {"name": "Icon (Dashboard)"},
                                {"name": "Icon (Salary)"},
                                {"name": "Icon (Expense)"},
                                {"name": "Icon (Search)"},
                                {"name": "Icon (Profile)"}
                            ]
                        }
                    ]
                }]
            }]
        }
    },
    {
        "num": 19,
        "title": "19. Expense Navigation",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {
                            "name": "Body",
                            "children": [
                                {"name": "Log Expense"}
                            ]
                        },
                        {
                            "name": "BottomNavigationBar",
                            "children": [
                                {"name": "Icon (Dashboard)"},
                                {"name": "Icon (Salary)"},
                                {"name": "Icon (Expense)"},
                                {"name": "Icon (Search)"},
                                {"name": "Icon (Profile)"}
                            ]
                        }
                    ]
                }]
            }]
        }
    },
    {
        "num": 20,
        "title": "20. Search / Profile Navigation",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "Column",
                    "children": [
                        {
                            "name": "Body",
                            "children": [
                                {"name": "Search Screen"},
                                {"name": "Profile & Settings"}
                            ]
                        },
                        {
                            "name": "BottomNavigationBar",
                            "children": [
                                {"name": "Icon (Dashboard)"},
                                {"name": "Icon (Salary)"},
                                {"name": "Icon (Expense)"},
                                {"name": "Icon (Search)"},
                                {"name": "Icon (Profile)"}
                            ]
                        }
                    ]
                }]
            }]
        }
    },
    # ── Additional App Screens ──
    {
        "num": 21,
        "title": "21. Goals & Savings",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {
                                "name": "Container (Available Savings)",
                                "children": [
                                    {"name": "Text (Available Savings)"},
                                    {"name": "Text (Total Amount)"},
                                    {"name": "Divider"},
                                    {"name": "Row (Summary Stats)"}
                                ]
                            },
                            {"name": "Text (My Goals)"},
                            {
                                "name": "ListView",
                                "children": [
                                    {"name": "GoalCard (Emergency Fund)"},
                                    {"name": "GoalCard (Vacation)"},
                                    {"name": "GoalCard (New Laptop)"}
                                ]
                            },
                            {"name": "FloatingActionButton (New Goal)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 22,
        "title": "22. Monthly Reports",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {"name": "ListView (Period Filter)"},
                            {
                                "name": "Container (Net Balance)",
                                "children": [
                                    {"name": "Text (Net Balance)"},
                                    {"name": "Text (Amount)"},
                                    {"name": "Divider"},
                                    {"name": "Row (Income, Expense, Rate)"}
                                ]
                            },
                            {"name": "Text (Expense by Category)"},
                            {
                                "name": "Container (Category Breakdown)",
                                "children": [
                                    {"name": "CategoryBar (Food)"},
                                    {"name": "CategoryBar (Bills)"},
                                    {"name": "CategoryBar (Transport)"}
                                ]
                            },
                            {"name": "Text (Transactions)"},
                            {
                                "name": "ListView",
                                "children": [
                                    {"name": "TransactionTile (Salary)"},
                                    {"name": "TransactionTile (Shopping)"},
                                    {"name": "TransactionTile (Electricity)"}
                                ]
                            },
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 23,
        "title": "23. Net Worth",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "ListView",
                    "children": [
                        {"name": "AppBar"},
                        {
                            "name": "Container (Net Worth)",
                            "children": [
                                {"name": "Text (Net Worth)"},
                                {"name": "Text (Amount)"},
                                {"name": "Divider"},
                                {"name": "Row (Assets, Liabilities, Health)"}
                            ]
                        },
                        {
                            "name": "Container (Debt-to-Asset)",
                            "children": [
                                {"name": "Text (Debt-to-Asset Ratio)"},
                                {"name": "LinearProgressIndicator"}
                            ]
                        },
                        {
                            "name": "Container (Asset Breakdown)",
                            "children": [
                                {"name": "CategoryProgress (Cash)"},
                                {"name": "CategoryProgress (Investments)"},
                                {"name": "CategoryProgress (Property)"}
                            ]
                        },
                        {"name": "Text (Assets)"},
                        {"name": "ItemTile (Savings Account)"},
                        {"name": "ItemTile (Investment Portfolio)"},
                        {"name": "Text (Liabilities)"},
                        {"name": "ItemTile (Credit Card Debt)"},
                        {"name": "ItemTile (Student Loan)"},
                        {"name": "FloatingActionButton (Add Item)"},
                        {"name": "BottomNavigationBar"}
                    ]
                }]
            }]
        }
    },
    {
        "num": 24,
        "title": "24. Export Data",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {
                                "name": "Card (Export Options)",
                                "children": [
                                    {"name": "Row (Format: CSV / Text)"},
                                    {"name": "Dropdown (Select Period)"},
                                    {"name": "CheckboxListTile (Income)"},
                                    {"name": "CheckboxListTile (Expenses)"}
                                ]
                            },
                            {
                                "name": "Card (Summary Preview)",
                                "children": [
                                    {"name": "Text (Preview Content)"}
                                ]
                            },
                            {"name": "ElevatedButton (Copy to Clipboard)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 25,
        "title": "25. Analytics & Insights",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {"name": "Text (Financial Analytics)"},
                            {
                                "name": "GridView",
                                "children": [
                                    {"name": "StatCard (Total Transactions)"},
                                    {"name": "StatCard (Average Expense)"},
                                    {"name": "StatCard (Savings Ratio)"},
                                    {"name": "StatCard (Highest Expense)"}
                                ]
                            },
                            {"name": "Text (Monthly Spending Trend)"},
                            {"name": "Container (Bar Chart Preview)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 26,
        "title": "26. Tax Estimator",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {
                                "name": "Card (Tax Inputs)",
                                "children": [
                                    {"name": "TextField (Annual Income)"},
                                    {"name": "TextField (Deductions)"},
                                    {"name": "DropdownButton (Tax Region)"},
                                    {"name": "ElevatedButton (Calculate Tax)"}
                                ]
                            },
                            {
                                "name": "Card (Tax Summary)",
                                "children": [
                                    {"name": "Text (Estimated Tax Owed)"},
                                    {"name": "Text (Effective Tax Rate)"},
                                    {"name": "Text (Estimated Net Income)"}
                                ]
                            },
                            {"name": "Text (Tax Saving Tips)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    },
    {
        "num": 27,
        "title": "27. App Info / About",
        "tree": {
            "name": "Scaffold",
            "children": [{
                "name": "SafeArea",
                "children": [{
                    "name": "SingleChildScrollView",
                    "children": [{
                        "name": "Column",
                        "children": [
                            {"name": "AppBar"},
                            {
                                "name": "Container (App Brand)",
                                "children": [
                                    {"name": "Icon (App Logo)"},
                                    {"name": "Text (Expense Tracker Pro)"},
                                    {"name": "Text (Version 2.0)"}
                                ]
                            },
                            {
                                "name": "Card (Features)",
                                "children": [
                                    {"name": "ListTile (Offline Storage)"},
                                    {"name": "ListTile (Currency Converter)"},
                                    {"name": "ListTile (Data Export)"}
                                ]
                            },
                            {"name": "OutlinedButton (Reset All Data)"},
                            {"name": "BottomNavigationBar"}
                        ]
                    }]
                }]
            }]
        }
    }
]

print(f"Total pages configured: {len(PAGES)}")
