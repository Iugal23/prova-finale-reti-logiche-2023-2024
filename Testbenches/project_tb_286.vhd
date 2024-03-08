-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_286 is
end project_tb_286;

architecture project_tb_arch_286 of project_tb_286 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 573;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,213,0,108,0,38,0,65,0,84,0,200,0,59,0,184,0,0,0,218,0,223,0,196,0,0,0,222,0,142,0,251,0,138,0,250,0,18,0,138,0,179,0,51,0,140,0,244,0,170,0,89,0,169,0,84,0,132,0,0,0,36,0,0,0,0,0,28,0,8,0,0,0,0,0,249,0,0,0,218,0,0,0,212,0,0,0,116,0,23,0,0,0,217,0,8,0,27,0,44,0,0,0,0,0,152,0,82,0,54,0,0,0,98,0,171,0,19,0,103,0,42,0,203,0,217,0,193,0,0,0,24,0,0,0,97,0,0,0,0,0,249,0,4,0,103,0,103,0,200,0,136,0,139,0,36,0,125,0,0,0,0,0,133,0,6,0,0,0,218,0,55,0,0,0,0,0,64,0,235,0,255,0,238,0,0,0,98,0,74,0,172,0,36,0,158,0,175,0,133,0,114,0,87,0,11,0,153,0,45,0,43,0,234,0,0,0,225,0,250,0,177,0,29,0,183,0,186,0,0,0,19,0,104,0,128,0,113,0,0,0,168,0,212,0,0,0,167,0,0,0,154,0,158,0,0,0,0,0,0,0,91,0,248,0,0,0,170,0,0,0,33,0,185,0,138,0,128,0,0,0,227,0,68,0,214,0,58,0,7,0,60,0,128,0,0,0,0,0,25,0,41,0,112,0,237,0,0,0,179,0,191,0,147,0,187,0,0,0,2,0,35,0,0,0,23,0,5,0,230,0,91,0,10,0,0,0,6,0,68,0,225,0,74,0,122,0,255,0,176,0,74,0,207,0,179,0,171,0,155,0,0,0,238,0,146,0,252,0,188,0,47,0,0,0,16,0,137,0,240,0,176,0,192,0,211,0,0,0,121,0,21,0,169,0,123,0,73,0,153,0,17,0,165,0,63,0,185,0,50,0,77,0,0,0,240,0,232,0,48,0,180,0,87,0,248,0,173,0,150,0,0,0,39,0,0,0,120,0,166,0,243,0,1,0,104,0,47,0,57,0,0,0,169,0,183,0,0,0,0,0,249,0,204,0,205,0,209,0,117,0,213,0,227,0,154,0,96,0,160,0,252,0,0,0,0,0,0,0,220,0,31,0,69,0,0,0,0,0,255,0,127,0,131,0,0,0,0,0,112,0,158,0,18,0,159,0,158,0,136,0,78,0,39,0,250,0,51,0,40,0,92,0,216,0,104,0,150,0,61,0,0,0,0,0,27,0,6,0,30,0,209,0,221,0,130,0,217,0,97,0,177,0,0,0,130,0,210,0,249,0,0,0,14,0,0,0,0,0,21,0,140,0,41,0,0,0,168,0,0,0,67,0,0,0,182,0,155,0,53,0,107,0,0,0,0,0,83,0,28,0,20,0,157,0,76,0,0,0,0,0,122,0,253,0,58,0,7,0,28,0,174,0,11,0,120,0,149,0,199,0,23,0,48,0,0,0,92,0,0,0,0,0,0,0,221,0,33,0,182,0,90,0,141,0,46,0,0,0,69,0,131,0,0,0,131,0,31,0,0,0,79,0,183,0,0,0,7,0,0,0,72,0,115,0,0,0,0,0,40,0,0,0,245,0,0,0,0,0,114,0,220,0,0,0,20,0,0,0,81,0,214,0,212,0,246,0,0,0,22,0,42,0,97,0,243,0,167,0,0,0,43,0,75,0,76,0,13,0,40,0,51,0,158,0,153,0,11,0,15,0,164,0,147,0,26,0,0,0,255,0,48,0,98,0,251,0,148,0,212,0,23,0,133,0,120,0,63,0,194,0,119,0,249,0,0,0,0,0,19,0,115,0,25,0,236,0,0,0,161,0,15,0,108,0,221,0,198,0,0,0,176,0,87,0,68,0,254,0,125,0,0,0,16,0,249,0,193,0,209,0,112,0,0,0,64,0,110,0,27,0,155,0,0,0,69,0,191,0,253,0,212,0,108,0,59,0,0,0,117,0,0,0,7,0,67,0,3,0,224,0,0,0,222,0,115,0,0,0,0,0,61,0,65,0,0,0,21,0,149,0,118,0,0,0,71,0,4,0,247,0,82,0,166,0,216,0,11,0,122,0,143,0,149,0,139,0,197,0,0,0,191,0,111,0,214,0,0,0,0,0,41,0,123,0,236,0,153,0,236,0,0,0,7,0,123,0,0,0,160,0,109,0,82,0,251,0,51,0,251,0,111,0,34,0,250,0,0,0,0,0,15,0,78,0,237,0,0,0,57,0,83,0,13,0,0,0,197,0,230,0,43,0,244,0,76,0,0,0,27,0,99,0,8,0,155,0,164,0,0,0,15,0,0,0,142,0,243,0,74,0,185,0,105,0,13,0,221,0,145,0,176,0,79,0,66,0,225,0,65,0,0,0,79,0,251,0,118,0,0,0,91,0,110,0,35,0,131,0,75,0,95,0,7,0,11,0,133,0,171,0,173,0,103,0,0,0,0,0,0,0,0,0,0,0,42,0,189,0,0,0,189,0,0,0,195,0,16,0,118,0,20,0,50,0,228,0,139,0,0,0,53,0,150,0,185,0,83,0,70,0,0,0,252,0,43,0,180,0,73,0,234,0,166,0);
signal scenario_full  : scenario_type := (0,0,213,31,108,31,38,31,65,31,84,31,200,31,59,31,184,31,184,30,218,31,223,31,196,31,196,30,222,31,142,31,251,31,138,31,250,31,18,31,138,31,179,31,51,31,140,31,244,31,170,31,89,31,169,31,84,31,132,31,132,30,36,31,36,30,36,29,28,31,8,31,8,30,8,29,249,31,249,30,218,31,218,30,212,31,212,30,116,31,23,31,23,30,217,31,8,31,27,31,44,31,44,30,44,29,152,31,82,31,54,31,54,30,98,31,171,31,19,31,103,31,42,31,203,31,217,31,193,31,193,30,24,31,24,30,97,31,97,30,97,29,249,31,4,31,103,31,103,31,200,31,136,31,139,31,36,31,125,31,125,30,125,29,133,31,6,31,6,30,218,31,55,31,55,30,55,29,64,31,235,31,255,31,238,31,238,30,98,31,74,31,172,31,36,31,158,31,175,31,133,31,114,31,87,31,11,31,153,31,45,31,43,31,234,31,234,30,225,31,250,31,177,31,29,31,183,31,186,31,186,30,19,31,104,31,128,31,113,31,113,30,168,31,212,31,212,30,167,31,167,30,154,31,158,31,158,30,158,29,158,28,91,31,248,31,248,30,170,31,170,30,33,31,185,31,138,31,128,31,128,30,227,31,68,31,214,31,58,31,7,31,60,31,128,31,128,30,128,29,25,31,41,31,112,31,237,31,237,30,179,31,191,31,147,31,187,31,187,30,2,31,35,31,35,30,23,31,5,31,230,31,91,31,10,31,10,30,6,31,68,31,225,31,74,31,122,31,255,31,176,31,74,31,207,31,179,31,171,31,155,31,155,30,238,31,146,31,252,31,188,31,47,31,47,30,16,31,137,31,240,31,176,31,192,31,211,31,211,30,121,31,21,31,169,31,123,31,73,31,153,31,17,31,165,31,63,31,185,31,50,31,77,31,77,30,240,31,232,31,48,31,180,31,87,31,248,31,173,31,150,31,150,30,39,31,39,30,120,31,166,31,243,31,1,31,104,31,47,31,57,31,57,30,169,31,183,31,183,30,183,29,249,31,204,31,205,31,209,31,117,31,213,31,227,31,154,31,96,31,160,31,252,31,252,30,252,29,252,28,220,31,31,31,69,31,69,30,69,29,255,31,127,31,131,31,131,30,131,29,112,31,158,31,18,31,159,31,158,31,136,31,78,31,39,31,250,31,51,31,40,31,92,31,216,31,104,31,150,31,61,31,61,30,61,29,27,31,6,31,30,31,209,31,221,31,130,31,217,31,97,31,177,31,177,30,130,31,210,31,249,31,249,30,14,31,14,30,14,29,21,31,140,31,41,31,41,30,168,31,168,30,67,31,67,30,182,31,155,31,53,31,107,31,107,30,107,29,83,31,28,31,20,31,157,31,76,31,76,30,76,29,122,31,253,31,58,31,7,31,28,31,174,31,11,31,120,31,149,31,199,31,23,31,48,31,48,30,92,31,92,30,92,29,92,28,221,31,33,31,182,31,90,31,141,31,46,31,46,30,69,31,131,31,131,30,131,31,31,31,31,30,79,31,183,31,183,30,7,31,7,30,72,31,115,31,115,30,115,29,40,31,40,30,245,31,245,30,245,29,114,31,220,31,220,30,20,31,20,30,81,31,214,31,212,31,246,31,246,30,22,31,42,31,97,31,243,31,167,31,167,30,43,31,75,31,76,31,13,31,40,31,51,31,158,31,153,31,11,31,15,31,164,31,147,31,26,31,26,30,255,31,48,31,98,31,251,31,148,31,212,31,23,31,133,31,120,31,63,31,194,31,119,31,249,31,249,30,249,29,19,31,115,31,25,31,236,31,236,30,161,31,15,31,108,31,221,31,198,31,198,30,176,31,87,31,68,31,254,31,125,31,125,30,16,31,249,31,193,31,209,31,112,31,112,30,64,31,110,31,27,31,155,31,155,30,69,31,191,31,253,31,212,31,108,31,59,31,59,30,117,31,117,30,7,31,67,31,3,31,224,31,224,30,222,31,115,31,115,30,115,29,61,31,65,31,65,30,21,31,149,31,118,31,118,30,71,31,4,31,247,31,82,31,166,31,216,31,11,31,122,31,143,31,149,31,139,31,197,31,197,30,191,31,111,31,214,31,214,30,214,29,41,31,123,31,236,31,153,31,236,31,236,30,7,31,123,31,123,30,160,31,109,31,82,31,251,31,51,31,251,31,111,31,34,31,250,31,250,30,250,29,15,31,78,31,237,31,237,30,57,31,83,31,13,31,13,30,197,31,230,31,43,31,244,31,76,31,76,30,27,31,99,31,8,31,155,31,164,31,164,30,15,31,15,30,142,31,243,31,74,31,185,31,105,31,13,31,221,31,145,31,176,31,79,31,66,31,225,31,65,31,65,30,79,31,251,31,118,31,118,30,91,31,110,31,35,31,131,31,75,31,95,31,7,31,11,31,133,31,171,31,173,31,103,31,103,30,103,29,103,28,103,27,103,26,42,31,189,31,189,30,189,31,189,30,195,31,16,31,118,31,20,31,50,31,228,31,139,31,139,30,53,31,150,31,185,31,83,31,70,31,70,30,252,31,43,31,180,31,73,31,234,31,166,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
