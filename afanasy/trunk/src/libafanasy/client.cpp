#include "client.h"

#include <stdio.h>
#include <memory.h>

#include "environment.h"

#define AFOUTPUT
#undef AFOUTPUT
#include "../include/macrooutput.h"

using namespace af;

Client::Client( int flags, int Id):
   time_launch( 0),
   time_register( 0),
   time_update( 0),
   revision( 0)
{
   id = Id;
   if( flags & GetEnvironment )
   {
      af::NetIF::getNetIFs( netIFs, true);

      address.setPort( af::Environment::getClientPort());
      time_launch = time(NULL);
      username = af::Environment::getUserName();
      name = af::Environment::getHostName();
      revision = af::Environment::getAfanasyBuildVersion();
      version = af::Environment::getCGRUVersion();
   }
}

Client::~Client()
{
   for( int i = 0; i < netIFs.size(); i++) if( netIFs[i]) delete netIFs[i];
}

void Client::setRegisterTime()
{
   time_register = time( NULL);
   time_update = time_register;
}

int Client::calcWeight() const
{
   int weight = Node::calcWeight();
//printf("Client::calcWeight: Node::calcWeight: %d bytes\n", weight);
   weight += sizeof(Client) - sizeof( Node);
   weight += weigh( username);
   weight += weigh( version );
   weight += address.calcWeight();
   for( int i = 0; i < netIFs.size(); i++) weight += netIFs[i]->calcWeight();
//printf("Client::calcWeight: %d bytes ( sizeof Client = %d)\n", weight, sizeof( Client));
   return weight;
}
