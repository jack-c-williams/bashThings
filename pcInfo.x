#!/bin/bash
# Jack Williams
# this script creates a text file that has basic patient and scan parameters
# from DICOM header
# must be in main case directory
# inp: takes in current directory and finds the DCE exam
# outp: text file named pcInfo.txt that is stored in /pcxxx/register

pcNum=$(pwd | rev | cut -d "/" -f 1 | rev)

cd E*

seriesDCE=$(dcm_summary -a . | grep Series | grep 'DCE-nowrap ' | cut -d " " -f 2)
seriesDCE=$(echo $seriesDCE | cut -d " " -f 1)
echo $seriesDCE

cd ${seriesDCE}

numSlices=$(dcm_summary -s . | grep Dimensions | rev | cut -d " " -f 1 | rev)
examNum=$(($numSlices+1))

pwd

trigTime=$(dcmdump E*I${examNum}.DCM | grep TriggerTime)
trigTime=$(echo $trigTime | cut -d "[" -f 2 | cut -d "]" -f 1)

fa=$(dcmdump E*I${examNum}.DCM | grep FlipAngle)
fa=$(echo $fa | cut -d "[" -f 2 | cut -d "]" -f 1)

contrast=$(dcmdump E*I${examNum}.DCM | grep ContrastBolusAgent)
contrast=$(echo $contrast | cut -d "[" -f 2 | cut -d "]" -f 1)

weight=$(dcmdump E*I${examNum}.DCM | grep PatientWeight)
weight=$(echo $weight | cut -d "[" -f 2 | cut -d "]" -f 1)

scanner=$(dcmdump E*I${examNum}.DCM | grep StationName)
scanner=$(echo $scanner | cut -d "[" -f 2 | cut -d "]" -f 1)

ptName=$(dcmdump E*I${examNum}.DCM | grep PatientName)
ptName=$(echo $ptName | cut -d "[" -f 2 | cut -d "]" -f 1)

ptDOB=$(dcmdump E*I${examNum}.DCM | grep PatientBirthDate)
ptDOB=$(echo $ptDOB | cut -d "[" -f 2 | cut -d "]" -f 1)

studyDate=$(dcmdump E*I${examNum}.DCM | grep StudyDate)
studyDate=$(echo $studyDate | cut -d "[" -f 2 | cut -d "]" -f 1)

coil=$(dcmdump E*I${examNum}.DCM | grep ReceiveCoilName)
coil=$(echo $coil | cut -d "[" -f 2 | cut -d "]" -f 1)

TR=$(dcm_summary -s . | grep TR | cut -d " " -f 7)

cd ../../register


echo "Patient Name:    $ptName"
echo "Birth Date:      $ptDOB"
echo "Study Date:      $studyDate"
echo "Patient Weight:  $weight"
echo "Scanner:         $scanner"
echo "Coil Name:       $coil"
echo "Trigger Time:    $trigTime"
echo "Flip Angle:      $fa"
echo "Contrast:        $contrast"
echo "TR:              $TR"


touch pcInfo.txt
echo "${pcNum}" > pcInfo.txt
echo "Patient Name:    $ptName" >> pcInfo.txt
echo "Birth Date:      $ptDOB" >> pcInfo.txt
echo "Study Date:      $studyDate" >> pcInfo.txt
echo "Patient Weight:  $weight" >> pcInfo.txt
echo "Scanner:         $scanner" >> pcInfo.txt
echo "Coil Name:       $coil" >> pcInfo.txt
echo "Trigger Time:    $trigTime" >> pcInfo.txt
echo "Flip Angle:      $fa" >> pcInfo.txt
echo "Contrast:        $contrast" >> pcInfo.txt
echo "TR:              $TR" >> pcInfo.txt
