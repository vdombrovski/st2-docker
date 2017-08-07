version: '3'

services:
  stackstorm:
    image: __st2_docker_image__
    cap_add:
      - SYS_ADMIN
    security_opt:
      - seccomp:unconfined
    container_name: stackstorm
    env_file:
      - conf/stackstorm.env
      - conf/mongo.env
      - conf/rabbitmq.env
      - conf/postgres.env
      - conf/redis.env
    ports:
      - "443:443"
    networks:
      - public
      - private
      - ecosys
    volumes:
      - stackstorm-log-volume:/var/log
      - ./packs.dev:/opt/stackstorm/packs.dev
      - ./os:/tmp/packs
    links:
      - keystone:keystone
  keystone:
    image: __keystone_image__
    networks:
      - private


### External Services

  mongo:
    image: mongo:3.4
    container_name: mongo
    env_file:
      - conf/mongo.env
    networks:
      - private
    volumes:
      - mongo-volume:/data/db
  rabbitmq:
    image: rabbitmq:management
    container_name: rabbitmq
    env_file:
      - conf/rabbitmq.env
    networks:
      - private
    volumes:
      - rabbitmq-volume:/var/lib/rabbitmq
  postgres:
    image: postgres:latest
    container_name: postgres
    env_file:
      - conf/postgres.env
    networks:
      - private
    volumes:
      - postgres-volume:/var/lib/postgresql/data
  redis:
    image: redis:latest
    container_name: redis
    env_file:
      - conf/redis.env
    networks:
      - private
    volumes:
      - redis-volume:/data

volumes:
  mongo-volume:
  postgres-volume:
  rabbitmq-volume:
  redis-volume:
  stackstorm-log-volume:

networks:
  public:
    driver: bridge
  private:
    driver: bridge
