-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FastingPlan" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fastMinutes" INTEGER NOT NULL DEFAULT 720,
    "eatingMinutes" INTEGER NOT NULL DEFAULT 720,
    "startMinuteOfDay" INTEGER NOT NULL DEFAULT 1200,
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "paused" BOOLEAN NOT NULL DEFAULT false,
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "FastingPlan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FastingSession" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "planId" TEXT,
    "startedAtUtcMs" BIGINT NOT NULL,
    "targetMinutes" INTEGER NOT NULL,
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "endedAtUtcMs" BIGINT,
    "endReason" TEXT,
    "symptoms" JSONB NOT NULL DEFAULT '[]',
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "FastingSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WaterEntry" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "sessionId" TEXT,
    "milliliters" INTEGER NOT NULL,
    "loggedAtUtcMs" BIGINT NOT NULL,
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "WaterEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WeightEntry" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "kilograms" DOUBLE PRECISION NOT NULL,
    "loggedAtUtcMs" BIGINT NOT NULL,
    "note" TEXT,
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "WeightEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailyHealthLog" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "dateKey" TEXT NOT NULL,
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "calories" INTEGER NOT NULL DEFAULT 0,
    "steps" INTEGER NOT NULL DEFAULT 0,
    "stepSource" TEXT NOT NULL DEFAULT 'manual',
    "stepsSyncedAtUtcMs" BIGINT,
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "DailyHealthLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalorieEntry" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "dateKey" TEXT NOT NULL,
    "mealType" TEXT NOT NULL,
    "calories" INTEGER NOT NULL,
    "loggedAtUtcMs" BIGINT NOT NULL,
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "CalorieEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailyTask" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "kind" TEXT NOT NULL DEFAULT 'custom',
    "title" TEXT NOT NULL,
    "iconKey" TEXT NOT NULL,
    "colorKey" TEXT NOT NULL,
    "goalType" TEXT NOT NULL,
    "targetValue" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL,
    "quickIncrement" DOUBLE PRECISION NOT NULL,
    "weekdaysMask" INTEGER NOT NULL DEFAULT 127,
    "reminderMinute" INTEGER,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "createdAtUtcMs" BIGINT NOT NULL,
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "DailyTask_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TaskProgressEntry" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "taskId" TEXT NOT NULL,
    "dateKey" TEXT NOT NULL,
    "deltaValue" DOUBLE PRECISION NOT NULL,
    "goalSnapshot" DOUBLE PRECISION NOT NULL,
    "unitSnapshot" TEXT NOT NULL,
    "loggedAtUtcMs" BIGINT NOT NULL,
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "TaskProgressEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "email" TEXT,
    "displayName" TEXT NOT NULL,
    "isGuest" BOOLEAN NOT NULL DEFAULT true,
    "createdAtUtcMs" BIGINT NOT NULL,
    "revision" INTEGER NOT NULL DEFAULT 1,
    "updatedAtUtcMs" BIGINT NOT NULL,
    "deletedAtUtcMs" BIGINT,

    CONSTRAINT "UserProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SyncOpLog" (
    "id" TEXT NOT NULL,
    "idempotencyKey" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'applied',
    "appliedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SyncOpLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "FastingPlan_userId_updatedAtUtcMs_idx" ON "FastingPlan"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "FastingPlan_userId_id_key" ON "FastingPlan"("userId", "id");

-- CreateIndex
CREATE INDEX "FastingSession_userId_updatedAtUtcMs_idx" ON "FastingSession"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "FastingSession_userId_id_key" ON "FastingSession"("userId", "id");

-- CreateIndex
CREATE INDEX "WaterEntry_userId_updatedAtUtcMs_idx" ON "WaterEntry"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "WaterEntry_userId_id_key" ON "WaterEntry"("userId", "id");

-- CreateIndex
CREATE INDEX "WeightEntry_userId_updatedAtUtcMs_idx" ON "WeightEntry"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "WeightEntry_userId_id_key" ON "WeightEntry"("userId", "id");

-- CreateIndex
CREATE INDEX "DailyHealthLog_userId_updatedAtUtcMs_idx" ON "DailyHealthLog"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "DailyHealthLog_userId_id_key" ON "DailyHealthLog"("userId", "id");

-- CreateIndex
CREATE INDEX "CalorieEntry_userId_updatedAtUtcMs_idx" ON "CalorieEntry"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "CalorieEntry_userId_id_key" ON "CalorieEntry"("userId", "id");

-- CreateIndex
CREATE INDEX "DailyTask_userId_updatedAtUtcMs_idx" ON "DailyTask"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "DailyTask_userId_id_key" ON "DailyTask"("userId", "id");

-- CreateIndex
CREATE INDEX "TaskProgressEntry_userId_updatedAtUtcMs_idx" ON "TaskProgressEntry"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "TaskProgressEntry_userId_id_key" ON "TaskProgressEntry"("userId", "id");

-- CreateIndex
CREATE INDEX "UserProfile_userId_updatedAtUtcMs_idx" ON "UserProfile"("userId", "updatedAtUtcMs");

-- CreateIndex
CREATE UNIQUE INDEX "UserProfile_userId_id_key" ON "UserProfile"("userId", "id");

-- CreateIndex
CREATE UNIQUE INDEX "SyncOpLog_idempotencyKey_key" ON "SyncOpLog"("idempotencyKey");

-- CreateIndex
CREATE INDEX "SyncOpLog_userId_entityType_entityId_idx" ON "SyncOpLog"("userId", "entityType", "entityId");
