@echo off
echo Desplegando Build Web a Vercel...
cd build\web
vercel --prod
cd ..\..\
