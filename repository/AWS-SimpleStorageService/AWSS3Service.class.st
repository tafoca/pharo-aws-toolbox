Class {
	#name : #AWSS3Service,
	#superclass : #AWSService,
	#category : #'AWS-SimpleStorageService'
}

{ #category : #internal }
AWSS3Service >> signRequest: httpRequest [

	| params |

	"This header will set to the correct value in the sign logic."
	httpRequest headers at: AWSHeaders x_amz_content_sha256 put: 'required'.

	awsCredentials sessionToken notNil
		ifTrue: [ httpRequest headers at: AWSHeaders x_amz_security_token put: awsCredentials sessionToken ].
	
	"Set the service name and region explicitly because it cannot always be derived from the host name"	
	params := AWSSignerV4RequestParameters new initWithDatTime: DateAndTime now asUTC 
			service: 's3'
			region: self region.
	
	AWSSignerV4 new sign: httpRequest using: awsCredentials with: params
]