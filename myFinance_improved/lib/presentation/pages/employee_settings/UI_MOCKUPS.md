# Employee Settings - UI Mockups & Visual Design 🎨

## Desktop Layout (1200px+)

```
┌────────────────────────────────────────────────────────────────────────────┐
│ ◄ myFinance          Employee Settings                    🔍 Search  👤 Admin │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                                │
│ ┌─────────────────┬────────────────────────────────────────────────────────┐ │
│ │                 │                                                          │ │
│ │  FILTERS        │  25 Employees                              ⊞ ☰ ◈       │ │
│ │                 │ ┌────────────────────────────────────────────────────┐ │ │
│ │ ▼ Status        │ │  👤  John Smith                                     │ │ │
│ │ ☑ Active (23)   │ │      Manager • Store A                      ⋮     │ │ │
│ │ ☐ Inactive (2)  │ │      $5,000/month • Active                         │ │ │
│ │                 │ └────────────────────────────────────────────────────┘ │ │
│ │ ▼ Role          │ ┌────────────────────────────────────────────────────┐ │ │
│ │ ☐ All           │ │  👤  Sarah Johnson                                 │ │ │
│ │ ☑ Manager (3)   │ │      Senior Cashier • Store B               ⋮     │ │ │
│ │ ☑ Cashier (15)  │ │      $3,500/month • Active                         │ │ │
│ │ ☐ Admin (7)     │ └────────────────────────────────────────────────────┘ │ │
│ │                 │ ┌────────────────────────────────────────────────────┐ │ │
│ │ ▼ Store         │ │  👤  Mike Chen                                     │ │ │
│ │ ☑ Store A (12)  │ │      Cashier • Store A                      ⋮     │ │ │
│ │ ☑ Store B (13)  │ │      $18/hour • Active                             │ │ │
│ │                 │ └────────────────────────────────────────────────────┘ │ │
│ │                 │                                                          │ │
│ │ Sort By:        │            [Load More...]                                │ │
│ │ ○ Name A-Z      │                                                          │ │
│ │ ● Salary ↓      │                                                          │ │
│ │ ○ Join Date     │                                                          │ │
│ │                 │                                                          │ │
│ └─────────────────┴────────────────────────────────────────────────────────┘ │
│                                                                                │
│                                        [+] Add New Employee                    │
└────────────────────────────────────────────────────────────────────────────┘
```

## Mobile Layout (< 600px)

```
┌─────────────────────┐
│ ◄  Employee Settings│
│                     │
│ [🔍 Search...]  [⚙] │
├─────────────────────┤
│                     │
│ 👤 John Smith       │
│ Manager • Store A   │
│ $5,000/mo • Active  │
│─────────────────────│
│ 👤 Sarah Johnson    │
│ Sr. Cashier • Store │
│ $3,500/mo • Active  │
│─────────────────────│
│ 👤 Mike Chen        │
│ Cashier • Store A   │
│ $18/hr • Active     │
│                     │
│         ...         │
│                     │
│    [+] Add Employee │
└─────────────────────┘
```

## Employee Detail Modal

```
┌────────────────────────────────────────────────────────────┐
│                          ━━━                               │
│                                                            │
│     👤                    John Smith                    ✏️  │
│                          Manager                           │
│                      john@company.com                      │
│                                                            │
│ ┌──────┬────────┬──────────┬─────────────┬─────────┐     │
│ │Profile│Compensation│Attendance│Permissions│History│     │
│ └──────┴────────┴──────────┴─────────────┴─────────┘     │
│                                                            │
│  Current Salary                              [Edit]        │
│  ┌────────────────────────────────────────────────┐       │
│  │ $5,000                                         │       │
│  │ per month                                      │       │
│  │ Last updated: Jan 15, 2024                     │       │
│  └────────────────────────────────────────────────┘       │
│                                                            │
│  Total Compensation (This Month)                           │
│  ┌────────────────────────────────────────────────┐       │
│  │ Base Salary              $5,000                │       │
│  │ Overtime (10 hrs)        + $750                │       │
│  │ Performance Bonus        + $500                │       │
│  │ Late Deductions           - $50                │       │
│  │ ─────────────────────────────────              │       │
│  │ Total                   $6,200                 │       │
│  └────────────────────────────────────────────────┘       │
│                                                            │
│  Salary History                                            │
│  ┌────────────────────────────────────────────────┐       │
│  │ • Jan 2024    $4,500 → $5,000  (+11%)         │       │
│  │ • Jul 2023    $4,000 → $4,500  (+12.5%)       │       │
│  │ • Jan 2023    Hired at $4,000                 │       │
│  └────────────────────────────────────────────────┘       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

## Employee Card States

### Default State
```
┌─────────────────────────────────────────────┐
│ 👤  John Smith                         ⋮    │
│     Manager • Store A                       │
│     $5,000/month • Active ●                 │
└─────────────────────────────────────────────┘
```

### Hover State
```
┌─────────────────────────────────────────────┐
│ 👤  John Smith                     ✏️ 👁️ ⋮  │  ← Actions appear
│     Manager • Store A                       │
│     $5,000/month • Active ●                 │
└─────────────────────────────────────────────┘
  ↑ Subtle shadow increase
```

### Selected State
```
┌─────────────────────────────────────────────┐
│ ✓ 👤  John Smith                       ⋮    │  ← Checkbox for bulk
│     Manager • Store A                       │
│     $5,000/month • Active ●                 │
└─────────────────────────────────────────────┘
  ↑ Primary color border
```

## Quick Action Menu
```
                    ┌─────────────────┐
                    │ Edit Details    │
                    │ View Attendance │
                    │ Adjust Salary   │
                    │ Change Role     │
                    │ ─────────────── │
                    │ Deactivate      │
                    └─────────────────┘
```

## Filter Panel Components

### Status Filter
```
▼ Status
┌──────────────────────┐
│ ☑ Active      (23)   │
│ ☐ Inactive     (2)   │
│ ☐ On Leave     (0)   │
└──────────────────────┘
```

### Role Filter with Color Coding
```
▼ Role
┌──────────────────────┐
│ ☐ All                │
│ ☑ 🟣 Manager    (3)  │
│ ☑ 🔵 Cashier   (15)  │
│ ☐ 🟡 Admin      (7)  │
└──────────────────────┘
```

## Salary Edit Dialog

```
┌─────────────────────────────────────┐
│         Update Salary               │
│                                     │
│ Employee: John Smith                │
│ Current: $5,000/month              │
│                                     │
│ New Amount                          │
│ ┌─────────────────────────────┐    │
│ │ 5,500                       │    │
│ └─────────────────────────────┘    │
│                                     │
│ Type                                │
│ ○ Monthly  ● Hourly                │
│                                     │
│ Currency                            │
│ ┌─────────────────────────────┐    │
│ │ USD - US Dollar         ▼  │    │
│ └─────────────────────────────┘    │
│                                     │
│ Effective Date                      │
│ ┌─────────────────────────────┐    │
│ │ 2024-02-01            📅   │    │
│ └─────────────────────────────┘    │
│                                     │
│ Reason for Change                   │
│ ┌─────────────────────────────┐    │
│ │ Annual performance review   │    │
│ │                             │    │
│ └─────────────────────────────┘    │
│                                     │
│  [Cancel]          [Update Salary]  │
└─────────────────────────────────────┘
```

## Attendance Summary Widget

```
┌──────────────────────────────────────┐
│ Last 30 Days                    📊   │
├──────────────────────────────────────┤
│ Attendance Rate    ████████░░  95%   │
│ Late Arrivals                   2    │
│ Overtime Hours                 15.5  │
│ Leaves Taken                    1    │
└──────────────────────────────────────┘
```

## Performance Chart

```
┌──────────────────────────────────────┐
│ Performance Metrics             📈   │
├──────────────────────────────────────┤
│   100% ┤                             │
│    80% ┤      ╭─────╮                │
│    60% ┤  ╭───╯     ╰───╮            │
│    40% ┤──╯             ╰──          │
│    20% ┤                             │
│     0% └─────────────────────────    │
│        Jan  Feb  Mar  Apr  May       │
└──────────────────────────────────────┘
```

## Empty States

### No Employees
```
┌────────────────────────────────────────┐
│                                        │
│              👥                        │
│                                        │
│        No employees found              │
│                                        │
│    Add your first employee to          │
│    get started with management         │
│                                        │
│       [+] Add First Employee           │
│                                        │
└────────────────────────────────────────┘
```

### No Search Results
```
┌────────────────────────────────────────┐
│                                        │
│              🔍                        │
│                                        │
│     No employees match your            │
│         search criteria                │
│                                        │
│    Try adjusting your filters          │
│      or search terms                   │
│                                        │
│        [Clear Filters]                 │
│                                        │
└────────────────────────────────────────┘
```

## Loading States

### Initial Load
```
┌────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │ ← Shimmer
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
└────────────────────────────────────────┘
```

### Pagination Load
```
┌────────────────────────────────────────┐
│ [Previous employees displayed above]    │
│                                        │
│         ⟳ Loading more...              │
│                                        │
└────────────────────────────────────────┘
```

## Toast Notifications

### Success
```
┌─────────────────────────────┐
│ ✅ Salary updated           │
│    successfully             │
└─────────────────────────────┘
```

### Error
```
┌─────────────────────────────┐
│ ❌ Unable to update salary  │
│    Please try again         │
│              [Retry] [X]    │
└─────────────────────────────┘
```

## Color Scheme

- **Primary**: #5B5FCF (Toss Blue/Purple)
- **Success**: #22C55E (Green)
- **Error**: #EF4444 (Red)
- **Warning**: #F59E0B (Orange)
- **Surface**: #FBFBFB (Light Gray)
- **Background**: #FFFFFF (White)
- **Text Primary**: #171717 (Near Black)
- **Text Secondary**: #737373 (Gray)

## Typography

- **Headers**: Inter Bold, 24px
- **Subheaders**: Inter SemiBold, 20px
- **Body**: Inter Regular, 15px
- **Small**: Inter Regular, 13px
- **Amount**: JetBrains Mono Bold, 32px

## Spacing

- **Component Gap**: 16px
- **Card Padding**: 16px
- **Section Spacing**: 24px
- **Page Margin**: 24px