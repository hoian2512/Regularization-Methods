install.packages("glmnet")
library(glmnet)
data=read.csv("Hitters1.csv")
View(data)
x = model.matrix(Salary ~ ., data )[, -1]
y = data$Salary
summary(data)
grid = 10^seq(10 , -2 , length = 100)
ridge.mod = glmnet(x , y , alpha = 0, lambda = grid )

dim(coef(ridge.mod))

ridge.mod$lambda[50]
coef(ridge.mod)[, 50]
sqrt(sum(coef(ridge.mod)[-1,50]^2))

ridge.mod$lambda[60]
coef(ridge.mod)[, 60]
sqrt(sum(coef(ridge.mod)[-1,60]^2))

predict(ridge.mod, s = 50, type ="coefficients")

set.seed(1)
train=sample(1:nrow(x), nrow(x)/2)
test=(-train)
y.test=y[test]
y.test

ridge.mod = glmnet(x[train, ], y[train], alpha =0, lambda = grid , thresh = 1e-12)
ridge.pred = predict(ridge.mod , s = 4 , newx = x [ test , ])
mean((ridge.pred - y.test)^2)
mean((mean(y[train])- y.test)^2)

ridge.pred=predict(ridge.mod, s = 0 , newx = x[test , ], exact = T , x = x[train , ], y = y[train])
mean((ridge.pred-y.test)^2)

lm(y ~ x, subset = train)
predict(ridge.mod, s = 0, exact = T , type = "coefficients", x = x[train , ], y = y[ train ]) 

set.seed(1)
cv.out = cv.glmnet(x[train , ], y[train], alpha = 0)
plot(cv.out)
bestlam = cv.out$lambda.min
bestlam

ridge.pred = predict(ridge.mod, s = bestlam ,newx = x[test , ])

out = glmnet (x , y , alpha = 0)
predict(out, type = "coefficients", s = bestlam ) 
plot(ridge.mod)

lasso.coef <- predict(out, type = "coefficients", s = bestlam)
lasso.coef
lasso.coef[lasso.coef != 0]


