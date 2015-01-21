#Desired funtion defined as f(x)
f <- function(x) {x^3 + 4*x^2 - 10}

#Function returning the number of iterations required, with default initial values of a=1, b=2, and max iterations=1000
numiter <- function(eps, a=1, b=2, limit=1000) {
  #Checking if a root exists or not between the initial given values
  if(f(a)*f(b) > 0){
    print("No root exists in (a,b)")
    return(-1)
  }
  n=0;                            #Initializing 'n' which would contain the result after loop terminates
  while(abs(a-b) > eps) {         #Termination COndition
    c = (a+b)/2;
    if(f(c) == 0){               
      print(c)
      break
    }
    #Updating the value of a or b
    else if(f(c)*f(a) > 0){       #If f(a) and f(c) have same signs
      b=c
    }
    else{                         #If f(b) and f(c) have same signs
      a=c
    }
    #Increasing the counter by 1 in each iteration to keep track
    n <- n+1
  }
  cat('Estimated root with epsilon =',eps,'is',(a+b)/2,'and number of iterations required is',n,'\n')
  return(n)
}

#No of epsilons to be taken(of the form 10^-1, 10^-2, ... 10^-N)
N = 10

#Initializing the vector which would contain the no of iterations for different epsilons
nvec <- c()        

#Saving the result in vector by progressively appending current output of numiter(epsilon) to it
for(i in 1:N){
  k = numiter(10^(-1*i))
  nvec <- cbind(nvec, k);  
}

#Plotting the bar graph
barplot(nvec,width=1,space=1, names.arg=c(1:N),
        angle=90, main="Bisection Method",font.main = 11,
        xlab="Epsilon(in 10^-x)",ylab="No. of iterations",
        ylim=c(0,as.integer(nvec[length(nvec)]/10)*10+10))

#Iterations required for eps=10^-1, 10^-2, 10^-3, 10^-4 are  4, 7, 10, 14 respectively.
#Checking it for larger values of n(smaller 10^-n), we notice that graph grows linearly as expected
