#~/bin/bash
echo -e "There will be 3 Steps of Davidwei's Homework, Including:

         1. Openshift Installation and deploy a simple app to do smoke test
         2. CI/CD workflow configuration: Jenkins deploys openshift-tasks app，including HPA. 
	 3. Multitenancy Configuration：sets specific limits per label and limit range\n"

echo -n "Do you want to uninstall existing Openshift Cluster? yes or no:"
read ANS
case $ANS in yes)
sh $PWD/uninstall.sh
    ;;
esac 
echo "===================Let's begin to finish the homework!================================="

echo  "Let's go to do the first step, Install Openshift first"
sh $PWD/presskey.sh
sh $PWD/OCP_Install.sh

echo  "Let's go to do  smoke test of first step"
sh $PWD/presskey.sh
sh smoke_test.sh
echo  "===================Congratulations! You have install Openshift and do smoke test================"

echo  "Let's go to do the Second step, Do CI/CD workflow configuration"
sh $PWD/presskey.sh
sh $PWD/CICD.sh
echo  "Congratulations! You have finished do CI/CD workflow"

echo  "Let's go to do the third step, Do Multitenancy Configuration"
sh $PWD/presskey.sh
sh $PWD/mutlit.sh
echo  "Congratulations! You finished do Multitenancy Configuration"

echo "================Homework of Davidwei has been finshed!================================="
