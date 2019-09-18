<!DOCTYPE model>
<Option type="Map">
  <Option type="Map" name="children">
    <Option type="Map" name="native:centroids_1">
      <Option value="true" type="bool" name="active"/>
      <Option name="alg_config"/>
      <Option value="native:centroids" type="QString" name="alg_id"/>
      <Option value="Centroids" type="QString" name="component_description"/>
      <Option value="476.0776699029126" type="double" name="component_pos_x"/>
      <Option value="164" type="double" name="component_pos_y"/>
      <Option name="dependencies"/>
      <Option value="native:centroids_1" type="QString" name="id"/>
      <Option name="outputs"/>
      <Option value="true" type="bool" name="outputs_collapsed"/>
      <Option value="true" type="bool" name="parameters_collapsed"/>
      <Option type="Map" name="params">
        <Option type="List" name="ALL_PARTS">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="false" type="bool" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option value="citycenter" type="QString" name="parameter_name"/>
            <Option value="0" type="int" name="source"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option type="Map" name="native:meancoordinates_1">
      <Option value="true" type="bool" name="active"/>
      <Option name="alg_config"/>
      <Option value="native:meancoordinates" type="QString" name="alg_id"/>
      <Option value="Mean coordinate(s)" type="QString" name="component_description"/>
      <Option value="818.1747572815532" type="double" name="component_pos_x"/>
      <Option value="305.00970873786423" type="double" name="component_pos_y"/>
      <Option name="dependencies"/>
      <Option value="native:meancoordinates_1" type="QString" name="id"/>
      <Option name="outputs"/>
      <Option value="true" type="bool" name="outputs_collapsed"/>
      <Option value="true" type="bool" name="parameters_collapsed"/>
      <Option type="Map" name="params">
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option value="native:centroids_1" type="QString" name="child_id"/>
            <Option value="OUTPUT" type="QString" name="output_name"/>
            <Option value="1" type="int" name="source"/>
          </Option>
        </Option>
        <Option type="List" name="UID">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option type="invalid" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="WEIGHT">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option type="invalid" name="static_value"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option type="Map" name="qgis:fieldcalculator_1">
      <Option value="true" type="bool" name="active"/>
      <Option name="alg_config"/>
      <Option value="qgis:fieldcalculator" type="QString" name="alg_id"/>
      <Option value="Field calculator(distance)" type="QString" name="component_description"/>
      <Option value="272.8543689320388" type="double" name="component_pos_x"/>
      <Option value="447.0679611650486" type="double" name="component_pos_y"/>
      <Option type="StringList" name="dependencies">
        <Option value="native:meancoordinates_1" type="QString"/>
      </Option>
      <Option value="qgis:fieldcalculator_1" type="QString" name="id"/>
      <Option name="outputs"/>
      <Option value="true" type="bool" name="outputs_collapsed"/>
      <Option value="true" type="bool" name="parameters_collapsed"/>
      <Option type="Map" name="params">
        <Option type="List" name="FIELD_LENGTH">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="10" type="int" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_NAME">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="cbdDist" type="QString" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_PRECISION">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="3" type="int" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_TYPE">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="0" type="int" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FORMULA">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="distance(centroid($geometry), &#xd;&#xa;make_point(  @Mean_coordinate_s__OUTPUT_maxx , @Mean_coordinate_s__OUTPUT_maxy  ) &#xd;&#xa;)" type="QString" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option value="inputfeatures" type="QString" name="parameter_name"/>
            <Option value="0" type="int" name="source"/>
          </Option>
        </Option>
        <Option type="List" name="NEW_FIELD">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="true" type="bool" name="static_value"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option type="Map" name="qgis:fieldcalculator_2">
      <Option value="true" type="bool" name="active"/>
      <Option name="alg_config"/>
      <Option value="qgis:fieldcalculator" type="QString" name="alg_id"/>
      <Option value="Field calculator (direction)" type="QString" name="component_description"/>
      <Option value="709.1650485436892" type="double" name="component_pos_x"/>
      <Option value="553.2038834951458" type="double" name="component_pos_y"/>
      <Option name="dependencies"/>
      <Option value="qgis:fieldcalculator_2" type="QString" name="id"/>
      <Option type="Map" name="outputs">
        <Option type="Map" name="Direction Distance Output">
          <Option value="qgis:fieldcalculator_2" type="QString" name="child_id"/>
          <Option value="Direction Distance Output" type="QString" name="component_description"/>
          <Option value="909.1650485436892" type="double" name="component_pos_x"/>
          <Option value="598.2038834951458" type="double" name="component_pos_y"/>
          <Option type="invalid" name="default_value"/>
          <Option value="false" type="bool" name="mandatory"/>
          <Option value="Direction Distance Output" type="QString" name="name"/>
          <Option value="OUTPUT" type="QString" name="output_name"/>
        </Option>
      </Option>
      <Option value="false" type="bool" name="outputs_collapsed"/>
      <Option value="true" type="bool" name="parameters_collapsed"/>
      <Option type="Map" name="params">
        <Option type="List" name="FIELD_LENGTH">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="10" type="int" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_NAME">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="cdbDRCT" type="QString" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_PRECISION">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="3" type="int" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_TYPE">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="0" type="int" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="FORMULA">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="degrees(&#xd;&#xa;azimuth(make_point( @Mean_coordinate_s__OUTPUT_maxx,  @Mean_coordinate_s__OUTPUT_maxy),centroid($geometry)))" type="QString" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option value="qgis:fieldcalculator_1" type="QString" name="child_id"/>
            <Option value="OUTPUT" type="QString" name="output_name"/>
            <Option value="1" type="int" name="source"/>
          </Option>
        </Option>
        <Option type="List" name="NEW_FIELD">
          <Option type="Map">
            <Option value="2" type="int" name="source"/>
            <Option value="true" type="bool" name="static_value"/>
          </Option>
        </Option>
      </Option>
    </Option>
  </Option>
  <Option type="Map" name="help">
    <Option value="Robert Kelley with direction from Professor Holler, Middlebury College" type="QString" name="ALG_CREATOR"/>
    <Option value="This model enables you to find the distance and direction from all points in a layer to a specified point." type="QString" name="ALG_DESC"/>
    <Option value="Robert Kelley" type="QString" name="ALG_HELP_CREATOR"/>
    <Option value="" type="QString" name="ALG_VERSION"/>
    <Option value="" type="QString" name="SHORT_DESCRIPTION"/>
    <Option value="City center is the central buisness distrct of the urban area. This can be both a point that has been inported or the mean of several centroids which you must select beforehand on the layer." type="QString" name="citycenter"/>
    <Option value="This layer must be polygons. It is the layer from which the distance to the city center will be factored." type="QString" name="inputfeatures"/>
    <Option value="The output of this model is the distance (in meters) and direction (in degrees) of each polygon from the centeral area inserted to the algorithm." type="QString" name="qgis:fieldcalculator_2:Direction Distance Output"/>
  </Option>
  <Option name="modelVariables"/>
  <Option value="Middlebury" type="QString" name="model_group"/>
  <Option value="Distance and direction from Point" type="QString" name="model_name"/>
  <Option type="Map" name="parameterDefinitions">
    <Option type="Map" name="citycenter">
      <Option type="List" name="data_types">
        <Option value="-1" type="int"/>
      </Option>
      <Option type="invalid" name="default"/>
      <Option value="City Center" type="QString" name="description"/>
      <Option value="0" type="int" name="flags"/>
      <Option name="metadata"/>
      <Option value="citycenter" type="QString" name="name"/>
      <Option value="source" type="QString" name="parameter_type"/>
    </Option>
    <Option type="Map" name="inputfeatures">
      <Option type="List" name="data_types">
        <Option value="2" type="int"/>
      </Option>
      <Option type="invalid" name="default"/>
      <Option value="Input Features" type="QString" name="description"/>
      <Option value="0" type="int" name="flags"/>
      <Option name="metadata"/>
      <Option value="inputfeatures" type="QString" name="name"/>
      <Option value="vector" type="QString" name="parameter_type"/>
    </Option>
    <Option type="Map" name="qgis:fieldcalculator_2:Direction Distance Output">
      <Option value="true" type="bool" name="create_by_default"/>
      <Option value="-1" type="int" name="data_type"/>
      <Option type="invalid" name="default"/>
      <Option value="Direction Distance Output" type="QString" name="description"/>
      <Option value="0" type="int" name="flags"/>
      <Option name="metadata"/>
      <Option value="qgis:fieldcalculator_2:Direction Distance Output" type="QString" name="name"/>
      <Option value="sink" type="QString" name="parameter_type"/>
      <Option value="true" type="bool" name="supports_non_file_outputs"/>
    </Option>
  </Option>
  <Option type="Map" name="parameters">
    <Option type="Map" name="citycenter">
      <Option value="citycenter" type="QString" name="component_description"/>
      <Option value="340" type="double" name="component_pos_x"/>
      <Option value="60" type="double" name="component_pos_y"/>
      <Option value="citycenter" type="QString" name="name"/>
    </Option>
    <Option type="Map" name="inputfeatures">
      <Option value="inputfeatures" type="QString" name="component_description"/>
      <Option value="120" type="double" name="component_pos_x"/>
      <Option value="60" type="double" name="component_pos_y"/>
      <Option value="inputfeatures" type="QString" name="name"/>
    </Option>
  </Option>
</Option>
