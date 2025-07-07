# Data Models Documentation
## Expense Tracking App with Flutter & Supabase

### Table of Contents
1. [Overview](#overview)
2. [Core Models Architecture](#core-models-architecture)
3. [Database Schema](#database-schema)
4. [Business Logic Functions](#business-logic-functions)
5. [Row Level Security (RLS)](#row-level-security-rls)
6. [Key Relationships](#key-relationships)
7. [Feature Integration](#feature-integration)
8. [Implementation Priorities](#implementation-priorities)
9. [Flutter Integration Patterns](#flutter-integration-patterns)

---

## Overview

This documentation outlines the complete data model architecture for the expense tracking app, designed around a pay-per-feature SaaS model with asset sharing capabilities.

### Key Design Principles
- **Asset-Centric**: Users share "assets" (bank accounts, cards, cash) rather than entire accounts
- **Collaborative**: Shared users can create/edit transactions, owners control asset management
- **Multi-Currency**: Support for transactions in different currencies with conversion tracking
- **Feature-Limited**: Core functionality with purchasable feature expansions
- **Soft Delete**: 30-day backup period for deleted data

### Core Models Summary
1. **Assets** - Bank accounts, credit cards, cash wallets (shareable)
2. **Asset Shares** - Collaboration and permission management
3. **Categories** - System defaults + user-defined expense categories
4. **Transactions** - Income/expense entries with multi-currency support
5. **Recurring Transactions** - Automated transaction generation
6. **Budgets** - Per-asset spending limits and financial planning

---

## Core Models Architecture

### Model Hierarchy and Relationships

```
Users (from auth.users)
├── Assets (owned)
│   ├── Asset Shares (collaboration)
│   ├── Transactions (financial data)
│   ├── Budgets (spending limits)
│   └── Recurring Transactions (automation)
└── Categories (organization)
```

### Data Flow
1. User creates **Assets** (bank account, credit card, etc.)
2. User can **share** assets with other users
3. **Transactions** are created against assets by owners or shared users
4. **Categories** organize transactions for reporting
5. **Budgets** track spending against assets/categories
6. **Recurring Transactions** automate regular income/expenses

---

## Database Schema

### 1. Assets Model (Foundation)

```sql
CREATE TABLE public.assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Asset Details
  name TEXT NOT NULL,
  asset_type TEXT NOT NULL CHECK (asset_type IN ('bank_account', 'credit_card', 'cash', 'savings', 'investment')),
  currency TEXT NOT NULL DEFAULT 'KRW',
  icon TEXT, -- For UI representation
  color TEXT, -- Hex color for UI
  
  -- Balance Tracking
  current_balance DECIMAL(15,2) DEFAULT 0,
  initial_balance DECIMAL(15,2) DEFAULT 0,
  
  -- Soft Delete Support
  deleted_at TIMESTAMP WITH TIME ZONE NULL,
  deleted_backup_expires_at TIMESTAMP WITH TIME ZONE NULL,
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_assets_owner_id ON public.assets(owner_id);
CREATE INDEX idx_assets_deleted_at ON public.assets(deleted_at);
CREATE INDEX idx_assets_owner_active ON public.assets(owner_id) WHERE deleted_at IS NULL;
```

### 2. Asset Sharing Model (Collaboration)

```sql
CREATE TABLE public.asset_shares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  asset_id UUID NOT NULL REFERENCES public.assets(id) ON DELETE CASCADE,
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  shared_with_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Sharing Status
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'revoked')),
  
  -- Permissions (for future extensibility)
  permissions JSONB NOT NULL DEFAULT '{
    "can_create_transactions": true,
    "can_edit_transactions": true,
    "can_view_history": true
  }',
  
  -- Timestamps
  invited_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  responded_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure unique sharing per asset-user pair
  UNIQUE(asset_id, shared_with_id)
);

-- Indexes for performance
CREATE INDEX idx_asset_shares_asset_id ON public.asset_shares(asset_id);
CREATE INDEX idx_asset_shares_shared_with_id ON public.asset_shares(shared_with_id);
CREATE INDEX idx_asset_shares_status ON public.asset_shares(status);
```

### 3. Categories Model (Organization)

```sql
CREATE TABLE public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE, -- NULL for system defaults
  
  -- Category Details
  name TEXT NOT NULL,
  icon TEXT, -- Icon identifier for UI
  color TEXT, -- Hex color
  
  -- Category Type
  is_system_default BOOLEAN DEFAULT false,
  is_income_category BOOLEAN DEFAULT false, -- For salary, etc.
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure unique names per user (or system)
  UNIQUE(user_id, name)
);

-- Insert default categories
INSERT INTO public.categories (user_id, name, icon, is_system_default, is_income_category) VALUES
(NULL, 'Food & Dining', 'restaurant', true, false),
(NULL, 'Transportation', 'car', true, false),
(NULL, 'Shopping', 'shopping_bag', true, false),
(NULL, 'Entertainment', 'movie', true, false),
(NULL, 'Bills & Utilities', 'receipt', true, false),
(NULL, 'Healthcare', 'medical_services', true, false),
(NULL, 'Education', 'school', true, false),
(NULL, 'Travel', 'flight', true, false),
(NULL, 'Salary', 'work', true, true),
(NULL, 'Investment Returns', 'trending_up', true, true),
(NULL, 'Other Income', 'payments', true, true);

-- Indexes for performance
CREATE INDEX idx_categories_user_id ON public.categories(user_id);
CREATE INDEX idx_categories_system_defaults ON public.categories(is_system_default);
```

### 4. Transactions Model (Core Data)

```sql
CREATE TABLE public.transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  asset_id UUID NOT NULL REFERENCES public.assets(id) ON DELETE CASCADE,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  
  -- Transaction Details
  description TEXT NOT NULL,
  amount DECIMAL(15,2) NOT NULL, -- Original amount in transaction currency
  currency TEXT NOT NULL,
  
  -- Multi-currency Support
  converted_amount DECIMAL(15,2), -- Amount in asset's currency
  conversion_rate DECIMAL(10,6), -- Rate used for conversion
  asset_currency TEXT, -- Asset currency at time of transaction
  
  -- Transaction Type
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('income', 'expense', 'transfer')),
  
  -- Transfer Support (for future)
  transfer_to_asset_id UUID REFERENCES public.assets(id),
  
  -- Recurring Transaction Link
  recurring_transaction_id UUID REFERENCES public.recurring_transactions(id),
  
  -- Date and Time
  transaction_date DATE NOT NULL,
  transaction_time TIME WITH TIME ZONE DEFAULT NOW(),
  
  -- Soft Delete Support
  deleted_at TIMESTAMP WITH TIME ZONE NULL,
  deleted_by UUID REFERENCES auth.users(id),
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID NOT NULL REFERENCES auth.users(id) -- Track who created (for shared assets)
);

-- Indexes for performance
CREATE INDEX idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX idx_transactions_asset_id ON public.transactions(asset_id);
CREATE INDEX idx_transactions_category_id ON public.transactions(category_id);
CREATE INDEX idx_transactions_date ON public.transactions(transaction_date);
CREATE INDEX idx_transactions_type ON public.transactions(transaction_type);
CREATE INDEX idx_transactions_deleted_at ON public.transactions(deleted_at);
CREATE INDEX idx_transactions_recurring_id ON public.transactions(recurring_transaction_id);
```

### 5. Recurring Transactions Model (Automation)

```sql
CREATE TABLE public.recurring_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  asset_id UUID NOT NULL REFERENCES public.assets(id) ON DELETE CASCADE,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  
  -- Transaction Template
  description TEXT NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  currency TEXT NOT NULL,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('income', 'expense')),
  
  -- Recurrence Pattern
  frequency TEXT NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly')),
  interval_count INTEGER NOT NULL DEFAULT 1, -- Every X days/weeks/months
  
  -- Schedule Details
  day_of_week INTEGER CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday, for weekly
  day_of_month INTEGER CHECK (day_of_month BETWEEN 1 AND 31), -- For monthly
  
  -- Date Range
  start_date DATE NOT NULL,
  end_date DATE, -- NULL for indefinite
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  next_execution_date DATE,
  last_executed_at TIMESTAMP WITH TIME ZONE,
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_recurring_user_id ON public.recurring_transactions(user_id);
CREATE INDEX idx_recurring_asset_id ON public.recurring_transactions(asset_id);
CREATE INDEX idx_recurring_next_execution ON public.recurring_transactions(next_execution_date) WHERE is_active = true;
CREATE INDEX idx_recurring_active ON public.recurring_transactions(is_active);
```

### 6. Budgets Model (Financial Planning)

```sql
CREATE TABLE public.budgets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  asset_id UUID NOT NULL REFERENCES public.assets(id) ON DELETE CASCADE,
  category_id UUID REFERENCES public.categories(id) ON DELETE CASCADE, -- NULL for overall asset budget
  
  -- Budget Details
  name TEXT NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  currency TEXT NOT NULL,
  
  -- Budget Period
  period_type TEXT NOT NULL DEFAULT 'monthly' CHECK (period_type IN ('weekly', 'monthly', 'quarterly', 'yearly', 'custom')),
  period_start_date DATE NOT NULL,
  period_end_date DATE NOT NULL,
  
  -- Budget Behavior
  rollover_unused BOOLEAN DEFAULT false, -- Roll unused budget to next period
  alert_threshold_percentage INTEGER DEFAULT 80 CHECK (alert_threshold_percentage BETWEEN 1 AND 100),
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure unique budget per asset/category/period
  UNIQUE(asset_id, category_id, period_start_date)
);

-- Indexes for performance
CREATE INDEX idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX idx_budgets_asset_id ON public.budgets(asset_id);
CREATE INDEX idx_budgets_category_id ON public.budgets(category_id);
CREATE INDEX idx_budgets_period ON public.budgets(period_start_date, period_end_date);
CREATE INDEX idx_budgets_active ON public.budgets(is_active);
```

---

## Business Logic Functions

### 1. Asset Access Control

```sql
-- Function to check if user can access asset
CREATE OR REPLACE FUNCTION user_can_access_asset(user_uuid UUID, asset_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.assets 
    WHERE id = asset_uuid 
    AND (owner_id = user_uuid OR id IN (
      SELECT asset_id FROM public.asset_shares 
      WHERE shared_with_id = user_uuid 
      AND status = 'accepted'
    ))
    AND deleted_at IS NULL
  );
END;
$$;

-- Function to check if user owns asset
CREATE OR REPLACE FUNCTION user_owns_asset(user_uuid UUID, asset_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.assets 
    WHERE id = asset_uuid 
    AND owner_id = user_uuid
    AND deleted_at IS NULL
  );
END;
$$;
```

### 2. Feature Limit Enforcement

```sql
-- Function to check asset creation limits
CREATE OR REPLACE FUNCTION can_create_asset(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  current_count INTEGER;
  purchased_count INTEGER;
  base_limit INTEGER := 2;
BEGIN
  -- Count current assets
  SELECT COUNT(*) INTO current_count
  FROM public.assets
  WHERE owner_id = user_uuid AND deleted_at IS NULL;
  
  -- Get purchased asset count
  SELECT COALESCE((purchased_features->>'assets')::JSONB->>'count', '0')::INTEGER
  INTO purchased_count
  FROM public.profiles
  WHERE id = user_uuid;
  
  RETURN current_count < (base_limit + purchased_count);
END;
$$;

-- Function to check category creation limits
CREATE OR REPLACE FUNCTION can_create_category(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  current_count INTEGER;
  purchased_count INTEGER;
  base_limit INTEGER := 5;
BEGIN
  -- Count current user categories
  SELECT COUNT(*) INTO current_count
  FROM public.categories
  WHERE user_id = user_uuid;
  
  -- Get purchased category count
  SELECT COALESCE((purchased_features->>'categories')::JSONB->>'count', '0')::INTEGER
  INTO purchased_count
  FROM public.profiles
  WHERE id = user_uuid;
  
  RETURN current_count < (base_limit + purchased_count);
END;
$$;

-- Function to check recurring transaction limits
CREATE OR REPLACE FUNCTION can_create_recurring(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  current_count INTEGER;
  purchased_count INTEGER;
  base_limit INTEGER := 2;
BEGIN
  -- Count current recurring transactions
  SELECT COUNT(*) INTO current_count
  FROM public.recurring_transactions
  WHERE user_id = user_uuid;
  
  -- Get purchased recurring count
  SELECT COALESCE((purchased_features->>'recurring_transactions')::JSONB->>'count', '0')::INTEGER
  INTO purchased_count
  FROM public.profiles
  WHERE id = user_uuid;
  
  RETURN current_count < (base_limit + purchased_count);
END;
$$;

-- Function to check asset sharing limits
CREATE OR REPLACE FUNCTION can_share_asset(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  current_share_count INTEGER;
  user_sharing_enabled BOOLEAN;
BEGIN
  -- Check if user has sharing feature
  SELECT COALESCE((purchased_features->>'user_sharing')::JSONB->>'enabled', 'false')::BOOLEAN
  INTO user_sharing_enabled
  FROM public.profiles
  WHERE id = user_uuid;
  
  IF NOT user_sharing_enabled THEN
    RETURN false;
  END IF;
  
  -- Count current active shares
  SELECT COUNT(*) INTO current_share_count
  FROM public.asset_shares
  WHERE owner_id = user_uuid AND status = 'accepted';
  
  -- Base limit is 1 asset sharing
  RETURN current_share_count < 1;
END;
$$;
```

### 3. Balance Calculation

```sql
-- Function to calculate asset balance
CREATE OR REPLACE FUNCTION calculate_asset_balance(asset_uuid UUID)
RETURNS DECIMAL(15,2)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  initial_bal DECIMAL(15,2);
  transaction_sum DECIMAL(15,2);
BEGIN
  -- Get initial balance
  SELECT initial_balance INTO initial_bal
  FROM public.assets
  WHERE id = asset_uuid;
  
  -- Sum all transactions (income positive, expense negative)
  SELECT COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN converted_amount
      WHEN transaction_type = 'expense' THEN -converted_amount
      ELSE 0
    END
  ), 0) INTO transaction_sum
  FROM public.transactions
  WHERE asset_id = asset_uuid AND deleted_at IS NULL;
  
  RETURN initial_bal + transaction_sum;
END;
$$;

-- Trigger to update asset balance when transactions change
CREATE OR REPLACE FUNCTION update_asset_balance()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  -- Update balance for the affected asset
  UPDATE public.assets
  SET 
    current_balance = calculate_asset_balance(COALESCE(NEW.asset_id, OLD.asset_id)),
    updated_at = NOW()
  WHERE id = COALESCE(NEW.asset_id, OLD.asset_id);
  
  RETURN COALESCE(NEW, OLD);
END;
$$;

-- Create triggers for balance updates
CREATE TRIGGER update_balance_on_insert
  AFTER INSERT ON public.transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_asset_balance();

CREATE TRIGGER update_balance_on_update
  AFTER UPDATE ON public.transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_asset_balance();

CREATE TRIGGER update_balance_on_delete
  AFTER DELETE ON public.transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_asset_balance();
```

### 4. Currency Conversion Helper

```sql
-- Function to handle currency conversion
CREATE OR REPLACE FUNCTION convert_currency_amount(
  original_amount DECIMAL(15,2),
  from_currency TEXT,
  to_currency TEXT,
  conversion_rate DECIMAL(10,6)
)
RETURNS DECIMAL(15,2)
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
  -- If same currency, no conversion needed
  IF from_currency = to_currency THEN
    RETURN original_amount;
  END IF;
  
  -- Apply conversion rate
  RETURN ROUND(original_amount * conversion_rate, 2);
END;
$$;
```

### 5. Recurring Transaction Processing

```sql
-- Function to process recurring transactions
CREATE OR REPLACE FUNCTION process_recurring_transactions()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  rec_transaction RECORD;
  transactions_created INTEGER := 0;
  next_date DATE;
BEGIN
  -- Find recurring transactions that need to be executed
  FOR rec_transaction IN 
    SELECT * FROM public.recurring_transactions
    WHERE is_active = true 
    AND next_execution_date <= CURRENT_DATE
    AND (end_date IS NULL OR next_execution_date <= end_date)
  LOOP
    -- Create the transaction
    INSERT INTO public.transactions (
      user_id, asset_id, category_id, description, amount, currency,
      converted_amount, conversion_rate, asset_currency, transaction_type,
      transaction_date, recurring_transaction_id, created_by
    )
    SELECT 
      rec_transaction.user_id,
      rec_transaction.asset_id,
      rec_transaction.category_id,
      rec_transaction.description,
      rec_transaction.amount,
      rec_transaction.currency,
      rec_transaction.amount, -- Assume same currency for now
      1.0, -- Same currency conversion rate
      (SELECT currency FROM public.assets WHERE id = rec_transaction.asset_id),
      rec_transaction.transaction_type,
      rec_transaction.next_execution_date,
      rec_transaction.id,
      rec_transaction.user_id;
    
    -- Calculate next execution date
    CASE rec_transaction.frequency
      WHEN 'daily' THEN
        next_date := rec_transaction.next_execution_date + (rec_transaction.interval_count || ' days')::interval;
      WHEN 'weekly' THEN
        next_date := rec_transaction.next_execution_date + (rec_transaction.interval_count || ' weeks')::interval;
      WHEN 'monthly' THEN
        next_date := rec_transaction.next_execution_date + (rec_transaction.interval_count || ' months')::interval;
    END CASE;
    
    -- Update recurring transaction
    UPDATE public.recurring_transactions
    SET 
      last_executed_at = NOW(),
      next_execution_date = CASE 
        WHEN rec_transaction.end_date IS NULL OR next_date <= rec_transaction.end_date 
        THEN next_date 
        ELSE NULL 
      END,
      is_active = CASE 
        WHEN rec_transaction.end_date IS NULL OR next_date <= rec_transaction.end_date 
        THEN true 
        ELSE false 
      END,
      updated_at = NOW()
    WHERE id = rec_transaction.id;
    
    transactions_created := transactions_created + 1;
  END LOOP;
  
  RETURN transactions_created;
END;
$$;
```

---

## Row Level Security (RLS)

### 1. Assets RLS Policies

```sql
ALTER TABLE public.assets ENABLE ROW LEVEL SECURITY;

-- Users can see assets they own or are shared with
CREATE POLICY "Users can view accessible assets" 
ON public.assets FOR SELECT 
TO authenticated 
USING (
  owner_id = (SELECT auth.uid()) OR
  id IN (
    SELECT asset_id FROM public.asset_shares 
    WHERE shared_with_id = (SELECT auth.uid()) 
    AND status = 'accepted'
  )
);

-- Only owners can update assets
CREATE POLICY "Owners can update assets" 
ON public.assets FOR UPDATE 
TO authenticated 
USING (owner_id = (SELECT auth.uid()));

-- Users can create assets if within limits
CREATE POLICY "Users can create assets within limits" 
ON public.assets FOR INSERT 
TO authenticated 
WITH CHECK (
  owner_id = (SELECT auth.uid()) AND
  can_create_asset((SELECT auth.uid()))
);

-- Only owners can delete assets
CREATE POLICY "Owners can delete assets" 
ON public.assets FOR DELETE 
TO authenticated 
USING (owner_id = (SELECT auth.uid()));
```

### 2. Asset Shares RLS Policies

```sql
ALTER TABLE public.asset_shares ENABLE ROW LEVEL SECURITY;

-- Users can view shares they're involved in
CREATE POLICY "Users can view relevant shares" 
ON public.asset_shares FOR SELECT 
TO authenticated 
USING (
  owner_id = (SELECT auth.uid()) OR 
  shared_with_id = (SELECT auth.uid())
);

-- Only asset owners can create shares
CREATE POLICY "Owners can create shares" 
ON public.asset_shares FOR INSERT 
TO authenticated 
WITH CHECK (
  owner_id = (SELECT auth.uid()) AND
  can_share_asset((SELECT auth.uid()))
);

-- Users can update shares they're involved in (for accepting/rejecting)
CREATE POLICY "Users can update relevant shares" 
ON public.asset_shares FOR UPDATE 
TO authenticated 
USING (
  owner_id = (SELECT auth.uid()) OR 
  shared_with_id = (SELECT auth.uid())
);

-- Only owners can delete shares
CREATE POLICY "Owners can delete shares" 
ON public.asset_shares FOR DELETE 
TO authenticated 
USING (owner_id = (SELECT auth.uid()));
```

### 3. Transactions RLS Policies

```sql
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Users can view transactions from accessible assets
CREATE POLICY "Users can view accessible transactions" 
ON public.transactions FOR SELECT 
TO authenticated 
USING (user_can_access_asset((SELECT auth.uid()), asset_id));

-- Users can create transactions on accessible assets
CREATE POLICY "Users can create transactions on accessible assets" 
ON public.transactions FOR INSERT 
TO authenticated 
WITH CHECK (
  user_can_access_asset((SELECT auth.uid()), asset_id) AND
  user_id = (SELECT auth.uid())
);

-- Users can update transactions they created or on assets they own
CREATE POLICY "Users can update own transactions or on owned assets" 
ON public.transactions FOR UPDATE 
TO authenticated 
USING (
  created_by = (SELECT auth.uid()) OR
  user_owns_asset((SELECT auth.uid()), asset_id)
);

-- Only asset owners can delete transactions
CREATE POLICY "Owners can delete transactions" 
ON public.transactions FOR DELETE 
TO authenticated 
USING (user_owns_asset((SELECT auth.uid()), asset_id));
```

### 4. Categories RLS Policies

```sql
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Users can view system defaults and their own categories
CREATE POLICY "Users can view accessible categories" 
ON public.categories FOR SELECT 
TO authenticated 
USING (
  is_system_default = true OR 
  user_id = (SELECT auth.uid())
);

-- Users can create categories if within limits
CREATE POLICY "Users can create categories within limits" 
ON public.categories FOR INSERT 
TO authenticated 
WITH CHECK (
  user_id = (SELECT auth.uid()) AND
  can_create_category((SELECT auth.uid()))
);

-- Users can update their own categories
CREATE POLICY "Users can update own categories" 
ON public.categories FOR UPDATE 
TO authenticated 
USING (user_id = (SELECT auth.uid()));

-- Users can delete their own categories
CREATE POLICY "Users can delete own categories" 
ON public.categories FOR DELETE 
TO authenticated 
USING (user_id = (SELECT auth.uid()));
```

### 5. Recurring Transactions RLS Policies

```sql
ALTER TABLE public.recurring_transactions ENABLE ROW LEVEL SECURITY;

-- Users can view recurring transactions on accessible assets
CREATE POLICY "Users can view accessible recurring transactions" 
ON public.recurring_transactions FOR SELECT 
TO authenticated 
USING (user_can_access_asset((SELECT auth.uid()), asset_id));

-- Users can create recurring transactions if within limits
CREATE POLICY "Users can create recurring transactions within limits" 
ON public.recurring_transactions FOR INSERT 
TO authenticated 
WITH CHECK (
  user_id = (SELECT auth.uid()) AND
  user_can_access_asset((SELECT auth.uid()), asset_id) AND
  can_create_recurring((SELECT auth.uid()))
);

-- Users can update recurring transactions they created or on owned assets
CREATE POLICY "Users can update own recurring transactions" 
ON public.recurring_transactions FOR UPDATE 
TO authenticated 
USING (
  user_id = (SELECT auth.uid()) OR
  user_owns_asset((SELECT auth.uid()), asset_id)
);

-- Only owners can delete recurring transactions
CREATE POLICY "Owners can delete recurring transactions" 
ON public.recurring_transactions FOR DELETE 
TO authenticated 
USING (user_owns_asset((SELECT auth.uid()), asset_id));
```

### 6. Budgets RLS Policies

```sql
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- Users can view budgets on accessible assets
CREATE POLICY "Users can view accessible budgets" 
ON public.budgets FOR SELECT 
TO authenticated 
USING (user_can_access_asset((SELECT auth.uid()), asset_id));

-- Users can create budgets on accessible assets
CREATE POLICY "Users can create budgets on accessible assets" 
ON public.budgets FOR INSERT 
TO authenticated 
WITH CHECK (
  user_id = (SELECT auth.uid()) AND
  user_can_access_asset((SELECT auth.uid()), asset_id)
);

-- Users can update budgets they created or on owned assets
CREATE POLICY "Users can update own budgets" 
ON public.budgets FOR UPDATE 
TO authenticated 
USING (
  user_id = (SELECT auth.uid()) OR
  user_owns_asset((SELECT auth.uid()), asset_id)
);

-- Only owners can delete budgets
CREATE POLICY "Owners can delete budgets" 
ON public.budgets FOR DELETE 
TO authenticated 
USING (user_owns_asset((SELECT auth.uid()), asset_id));
```

---

## Key Relationships

### Data Relationship Diagram

```
auth.users (Supabase Auth)
├── profiles (user settings, purchased features)
├── assets (owner_id) 
│   ├── asset_shares (asset_id, shared_with_id)
│   ├── transactions (asset_id, user_id, created_by)
│   ├── budgets (asset_id, user_id)
│   └── recurring_transactions (asset_id, user_id)
└── categories (user_id) - referenced by transactions
```

### Business Rule Enforcement

1. **Asset Ownership**: Each asset has one owner, multiple possible shared users
2. **Transaction Creation**: Any user with asset access can create transactions
3. **Transaction Management**: Only asset owners can delete transactions
4. **Feature Limits**: Enforced at database level through functions
5. **Soft Deletes**: 30-day backup period for assets and transactions
6. **Currency Handling**: Store original + converted amounts with rates
7. **Sharing Limits**: Base 1 share slot, expandable via feature purchase

---

## Feature Integration

### Pay-per-Feature Implementation

#### Feature Checking Pattern
```sql
-- Example feature check for dashboard charts
CREATE OR REPLACE FUNCTION user_has_dashboard_charts(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN COALESCE(
    (SELECT (purchased_features->>'dashboard_charts')::JSONB->>'enabled')::BOOLEAN
    FROM public.profiles
    WHERE id = user_uuid
  ), false);
END;
$$;
```

#### Feature Gate Examples
- **Assets**: 2 base + purchased additional
- **Categories**: 5 base + purchased additional  
- **User Sharing**: Requires purchase to enable
- **Dashboard Charts**: Requires purchase to view
- **Recurring Transactions**: 2 base + purchased additional

### Multi-Currency Support

#### Conversion Rate Storage
```sql
-- Every transaction stores:
-- 1. Original amount + currency
-- 2. Converted amount in asset currency
-- 3. Conversion rate used
-- 4. Asset currency at time of transaction
```

#### Currency Conversion Flow
1. User enters transaction in any currency
2. App prompts for conversion rate if different from asset currency
3. System stores both original and converted amounts
4. User can edit conversion rate later for accuracy
5. Balance calculations use converted amounts

---

## Implementation Priorities

### Phase 1: Core Functionality (Weeks 1-4)
1. **Assets Model** - Create, read, update, delete assets with feature limits
2. **Categories System** - System defaults + user custom categories
3. **Basic Transactions** - Income/expense tracking with single currency
4. **Feature Limit Enforcement** - Database functions to check limits
5. **RLS Implementation** - Security policies for all core tables

**Key Deliverables:**
- Users can create up to 2 assets (bank account, credit card, cash)
- Users can create up to 5 custom categories
- Basic transaction CRUD with category assignment
- Feature purchase tracking (foundation for later phases)

### Phase 2: Multi-Currency & Collaboration (Weeks 5-8)
1. **Multi-Currency Transactions** - Currency conversion and rate storage
2. **Asset Sharing System** - Invitation and permission management
3. **Shared Transaction Management** - Collaborative transaction handling
4. **Balance Calculation** - Real-time balance updates with currency handling

**Key Deliverables:**
- Transactions in multiple currencies with conversion tracking
- Asset sharing with pending/accepted/rejected status
- Shared users can create/edit transactions on shared assets
- Asset owners maintain full control over asset management

### Phase 3: Automation & Planning (Weeks 9-12)
1. **Recurring Transactions** - Automated transaction generation
2. **Budget Management** - Per-asset spending limits and tracking
3. **Advanced Analytics** - Spending reports and insights
4. **Feature Purchase Integration** - In-app feature purchasing

**Key Deliverables:**
- Recurring transactions with daily/weekly/monthly schedules
- Budget creation and monitoring with alerts
- Basic reporting and analytics dashboard
- Feature upgrade flows and limit expansion

### Phase 4: Polish & Advanced Features (Weeks 13+)
1. **Soft Delete Management** - Recovery and cleanup workflows
2. **Advanced Budgeting** - Category-specific budgets and rollover
3. **Notification System** - Budget alerts and transaction reminders
4. **Performance Optimization** - Database indexing and query optimization

---

## Flutter Integration Patterns

### 1. Freezed Data Models

```dart
// lib/models/asset.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

@freezed
class Asset with _$Asset {
  const factory Asset({
    required String id,
    required String ownerId,
    required String name,
    required AssetType assetType,
    required String currency,
    String? icon,
    String? color,
    @Default(0.0) double currentBalance,
    @Default(0.0) double initialBalance,
    DateTime? deletedAt,
    DateTime? deletedBackupExpiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    
    // Computed fields
    @Default([]) List<AssetShare> shares,
    @Default(false) bool isShared,
    @Default(false) bool isOwner,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}

enum AssetType {
  @JsonValue('bank_account')
  bankAccount,
  @JsonValue('credit_card')
  creditCard,
  @JsonValue('cash')
  cash,
  @JsonValue('savings')
  savings,
  @JsonValue('investment')
  investment,
}

@freezed
class AssetShare with _$AssetShare {
  const factory AssetShare({
    required String id,
    required String assetId,
    required String ownerId,
    required String sharedWithId,
    required ShareStatus status,
    required Map<String, dynamic> permissions,
    required DateTime invitedAt,
    DateTime? respondedAt,
    required DateTime createdAt,
    
    // Populated fields
    String? sharedWithEmail,
    String? sharedWithName,
  }) = _AssetShare;

  factory AssetShare.fromJson(Map<String, dynamic> json) => _$AssetShareFromJson(json);
}

enum ShareStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('revoked')
  revoked,
}
```

```dart
// lib/models/transaction.dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String userId,
    required String assetId,
    String? categoryId,
    required String description,
    required double amount,
    required String currency,
    double? convertedAmount,
    double? conversionRate,
    String? assetCurrency,
    required TransactionType transactionType,
    String? transferToAssetId,
    String? recurringTransactionId,
    required DateTime transactionDate,
    required DateTime transactionTime,
    DateTime? deletedAt,
    String? deletedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    
    // Populated fields
    String? categoryName,
    String? assetName,
    String? createdByEmail,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

enum TransactionType {
  @JsonValue('income')
  income,
  @JsonValue('expense')
  expense,
  @JsonValue('transfer')
  transfer,
}
```

```dart
// lib/models/category.dart
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    String? userId,
    required String name,
    String? icon,
    String? color,
    @Default(false) bool isSystemDefault,
    @Default(false) bool isIncomeCategory,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
```

### 2. Repository Pattern Implementation

```dart
// lib/repositories/asset_repository.dart
abstract class AssetRepository {
  // Core CRUD
  Future<List<Asset>> getAccessibleAssets();
  Future<Asset?> getAssetById(String id);
  Future<Asset> createAsset(CreateAssetData data);
  Future<Asset> updateAsset(String id, UpdateAssetData data);
  Future<void> deleteAsset(String id);
  
  // Sharing
  Future<AssetShare> shareAsset(ShareAssetData data);
  Future<void> respondToShare(String shareId, ShareStatus status);
  Future<List<AssetShare>> getAssetShares(String assetId);
  Future<List<AssetShare>> getReceivedShares();
  
  // Feature limits
  Future<bool> canCreateAsset();
  Future<bool> canShareAsset();
  Future<int> getAssetLimit();
  Future<int> getCurrentAssetCount();
}

// lib/repositories/asset_repository_impl.dart
class AssetRepositoryImpl implements AssetRepository {
  final SupabaseClient _supabase;
  
  AssetRepositoryImpl(this._supabase);
  
  @override
  Future<List<Asset>> getAccessibleAssets() async {
    try {
      final response = await _supabase
          .from('assets')
          .select('''
            *,
            shares:asset_shares!asset_id(
              *,
              shared_with:auth.users!shared_with_id(email, raw_user_meta_data)
            )
          ''')
          .is_('deleted_at', null)
          .order('created_at', ascending: false);
      
      return response.map((json) => Asset.fromJson(json)).toList();
    } catch (e) {
      throw AssetException('Failed to fetch assets: $e');
    }
  }
  
  @override
  Future<Asset> createAsset(CreateAssetData data) async {
    try {
      // Check feature limits first
      final canCreate = await canCreateAsset();
      if (!canCreate) {
        throw AssetException('Asset creation limit reached. Purchase more assets to continue.');
      }
      
      final response = await _supabase
          .from('assets')
          .insert(data.toJson())
          .select()
          .single();
      
      return Asset.fromJson(response);
    } catch (e) {
      throw AssetException('Failed to create asset: $e');
    }
  }
  
  @override
  Future<AssetShare> shareAsset(ShareAssetData data) async {
    try {
      // Check sharing limits
      final canShare = await canShareAsset();
      if (!canShare) {
        throw AssetException('Asset sharing limit reached. Purchase sharing feature to continue.');
      }
      
      final response = await _supabase
          .from('asset_shares')
          .insert(data.toJson())
          .select('''
            *,
            shared_with:auth.users!shared_with_id(email, raw_user_meta_data)
          ''')
          .single();
      
      return AssetShare.fromJson(response);
    } catch (e) {
      throw AssetException('Failed to share asset: $e');
    }
  }
  
  @override
  Future<bool> canCreateAsset() async {
    try {
      final response = await _supabase.rpc('can_create_asset');
      return response as bool;
    } catch (e) {
      throw AssetException('Failed to check asset limits: $e');
    }
  }
}
```

```dart
// lib/repositories/transaction_repository.dart
abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions({
    String? assetId,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    int? limit,
    int? offset,
  });
  
  Future<Transaction> createTransaction(CreateTransactionData data);
  Future<Transaction> updateTransaction(String id, UpdateTransactionData data);
  Future<void> deleteTransaction(String id);
  Future<double> getAssetBalance(String assetId);
  Future<Map<String, double>> getCategorySpending({
    required DateTime startDate,
    required DateTime endDate,
    String? assetId,
  });
}

class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseClient _supabase;
  
  TransactionRepositoryImpl(this._supabase);
  
  @override
  Future<List<Transaction>> getTransactions({
    String? assetId,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from('transactions')
          .select('''
            *,
            category:categories(name),
            asset:assets(name),
            created_by_user:auth.users!created_by(email)
          ''')
          .is_('deleted_at', null);
      
      if (assetId != null) {
        query = query.eq('asset_id', assetId);
      }
      
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      
      if (startDate != null) {
        query = query.gte('transaction_date', startDate.toIso8601String());
      }
      
      if (endDate != null) {
        query = query.lte('transaction_date', endDate.toIso8601String());
      }
      
      if (type != null) {
        query = query.eq('transaction_type', type.name);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 50) - 1);
      }
      
      query = query.order('transaction_date', ascending: false);
      query = query.order('created_at', ascending: false);
      
      final response = await query;
      return response.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      throw TransactionException('Failed to fetch transactions: $e');
    }
  }
  
  @override
  Future<Transaction> createTransaction(CreateTransactionData data) async {
    try {
      final response = await _supabase
          .from('transactions')
          .insert(data.toJson())
          .select('''
            *,
            category:categories(name),
            asset:assets(name)
          ''')
          .single();
      
      return Transaction.fromJson(response);
    } catch (e) {
      throw TransactionException('Failed to create transaction: $e');
    }
  }
  
  @override
  Future<double> getAssetBalance(String assetId) async {
    try {
      final response = await _supabase.rpc('calculate_asset_balance', params: {
        'asset_uuid': assetId,
      });
      
      return (response as num).toDouble();
    } catch (e) {
      throw TransactionException('Failed to calculate balance: $e');
    }
  }
}
```

### 3. Riverpod State Management

```dart
// lib/providers/asset_providers.dart
@riverpod
class UserAssets extends _$UserAssets {
  @override
  Future<List<Asset>> build() async {
    final repository = ref.read(assetRepositoryProvider);
    return await repository.getAccessibleAssets();
  }
  
  Future<void> createAsset(CreateAssetData data) async {
    final repository = ref.read(assetRepositoryProvider);
    
    try {
      state = const AsyncValue.loading();
      final newAsset = await repository.createAsset(data);
      
      // Optimistically update the list
      final currentAssets = await future;
      state = AsyncValue.data([newAsset, ...currentAssets]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  Future<void> shareAsset(ShareAssetData data) async {
    final repository = ref.read(assetRepositoryProvider);
    
    try {
      await repository.shareAsset(data);
      // Refresh assets to show updated sharing status
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> deleteAsset(String assetId) async {
    final repository = ref.read(assetRepositoryProvider);
    
    try {
      await repository.deleteAsset(assetId);
      
      // Remove from current list
      final currentAssets = await future;
      final updatedAssets = currentAssets.where((asset) => asset.id != assetId).toList();
      state = AsyncValue.data(updatedAssets);
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
Future<List<AssetShare>> receivedShares(ReceivedSharesRef ref) async {
  final repository = ref.read(assetRepositoryProvider);
  return await repository.getReceivedShares();
}

@riverpod
Future<bool> canCreateAsset(CanCreateAssetRef ref) async {
  final repository = ref.read(assetRepositoryProvider);
  return await repository.canCreateAsset();
}

@riverpod
Future<bool> canShareAsset(CanShareAssetRef ref) async {
  final repository = ref.read(assetRepositoryProvider);
  return await repository.canShareAsset();
}
```

```dart
// lib/providers/transaction_providers.dart
@riverpod
class AssetTransactions extends _$AssetTransactions {
  @override
  Future<List<Transaction>> build(String assetId) async {
    final repository = ref.read(transactionRepositoryProvider);
    return await repository.getTransactions(
      assetId: assetId,
      limit: 50,
    );
  }
  
  Future<void> createTransaction(CreateTransactionData data) async {
    final repository = ref.read(transactionRepositoryProvider);
    
    try {
      state = const AsyncValue.loading();
      final newTransaction = await repository.createTransaction(data);
      
      // Update the transactions list
      final currentTransactions = await future;
      state = AsyncValue.data([newTransaction, ...currentTransactions]);
      
      // Invalidate related providers
      ref.invalidate(assetBalanceProvider(data.assetId));
      ref.invalidate(userAssetsProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  Future<void> updateTransaction(String id, UpdateTransactionData data) async {
    final repository = ref.read(transactionRepositoryProvider);
    
    try {
      final updatedTransaction = await repository.updateTransaction(id, data);
      
      // Update the transaction in the list
      final currentTransactions = await future;
      final updatedList = currentTransactions.map((transaction) {
        return transaction.id == id ? updatedTransaction : transaction;
      }).toList();
      
      state = AsyncValue.data(updatedList);
      
      // Invalidate related providers
      ref.invalidate(assetBalanceProvider(updatedTransaction.assetId));
      ref.invalidate(userAssetsProvider);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> deleteTransaction(String id) async {
    final repository = ref.read(transactionRepositoryProvider);
    final currentTransactions = await future;
    final transaction = currentTransactions.firstWhere((t) => t.id == id);
    
    try {
      await repository.deleteTransaction(id);
      
      // Remove from current list
      final updatedList = currentTransactions.where((t) => t.id != id).toList();
      state = AsyncValue.data(updatedList);
      
      // Invalidate related providers
      ref.invalidate(assetBalanceProvider(transaction.assetId));
      ref.invalidate(userAssetsProvider);
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
Future<double> assetBalance(AssetBalanceRef ref, String assetId) async {
  final repository = ref.read(transactionRepositoryProvider);
  return await repository.getAssetBalance(assetId);
}

@riverpod
Future<Map<String, double>> categorySpending(
  CategorySpendingRef ref, {
  required DateTime startDate,
  required DateTime endDate,
  String? assetId,
}) async {
  final repository = ref.read(transactionRepositoryProvider);
  return await repository.getCategorySpending(
    startDate: startDate,
    endDate: endDate,
    assetId: assetId,
  );
}
```

### 4. Data Transfer Objects

```dart
// lib/dto/asset_dto.dart
@freezed
class CreateAssetData with _$CreateAssetData {
  const factory CreateAssetData({
    required String name,
    required AssetType assetType,
    required String currency,
    String? icon,
    String? color,
    @Default(0.0) double initialBalance,
  }) = _CreateAssetData;
  
  factory CreateAssetData.fromJson(Map<String, dynamic> json) => _$CreateAssetDataFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'owner_id': null, // Set by database
    'name': name,
    'asset_type': assetType.name,
    'currency': currency,
    'icon': icon,
    'color': color,
    'initial_balance': initialBalance,
    'current_balance': initialBalance,
  };
}

@freezed
class ShareAssetData with _$ShareAssetData {
  const factory ShareAssetData({
    required String assetId,
    required String sharedWithEmail,
  }) = _ShareAssetData;
  
  Map<String, dynamic> toJson() => {
    'asset_id': assetId,
    'owner_id': null, // Set by database
    'shared_with_id': null, // Resolved by email lookup
    'shared_with_email': sharedWithEmail,
  };
}
```

```dart
// lib/dto/transaction_dto.dart
@freezed
class CreateTransactionData with _$CreateTransactionData {
  const factory CreateTransactionData({
    required String assetId,
    String? categoryId,
    required String description,
    required double amount,
    required String currency,
    double? conversionRate,
    required TransactionType transactionType,
    required DateTime transactionDate,
  }) = _CreateTransactionData;
  
  Map<String, dynamic> toJson() => {
    'user_id': null, // Set by database
    'asset_id': assetId,
    'category_id': categoryId,
    'description': description,
    'amount': amount,
    'currency': currency,
    'conversion_rate': conversionRate ?? 1.0,
    'transaction_type': transactionType.name,
    'transaction_date': transactionDate.toIso8601String().split('T')[0],
    'created_by': null, // Set by database
  };
}
```

### 5. Error Handling

```dart
// lib/exceptions/asset_exception.dart
class AssetException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AssetException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => 'AssetException: $message';
}

class TransactionException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const TransactionException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => 'TransactionException: $message';
}
```

---

## Conclusion

This comprehensive data model architecture provides:

- **Scalable Foundation**: Modular design that grows with feature additions
- **Collaborative Features**: Asset sharing with proper permission management
- **Financial Accuracy**: Multi-currency support with conversion tracking
- **Feature Monetization**: Built-in limits and purchase tracking
- **Data Integrity**: Strong relationships and business rule enforcement
- **Security**: Row-level security ensuring proper data access
- **Performance**: Optimized queries and proper indexing

The implementation follows Flutter and Supabase best practices while supporting your innovative pay-per-feature business model. Each phase builds upon the previous one, allowing for iterative development and testing.

Next steps would involve implementing the Flutter UI components and integrating with your user profile system for a complete expense tracking solution.