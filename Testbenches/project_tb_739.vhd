-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 612;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (249,0,0,0,85,0,253,0,241,0,32,0,211,0,0,0,1,0,24,0,0,0,82,0,0,0,0,0,56,0,133,0,252,0,0,0,0,0,187,0,205,0,136,0,63,0,166,0,10,0,47,0,201,0,109,0,0,0,0,0,87,0,217,0,106,0,0,0,226,0,50,0,250,0,11,0,253,0,13,0,221,0,206,0,123,0,0,0,58,0,111,0,0,0,232,0,189,0,237,0,5,0,232,0,199,0,12,0,0,0,0,0,156,0,163,0,230,0,18,0,197,0,0,0,68,0,0,0,79,0,66,0,8,0,214,0,0,0,0,0,0,0,0,0,111,0,109,0,251,0,0,0,0,0,94,0,0,0,231,0,0,0,0,0,200,0,0,0,23,0,0,0,0,0,213,0,196,0,133,0,26,0,0,0,0,0,194,0,199,0,117,0,73,0,38,0,3,0,14,0,193,0,0,0,155,0,62,0,0,0,0,0,197,0,0,0,0,0,65,0,82,0,58,0,134,0,205,0,89,0,0,0,181,0,249,0,0,0,107,0,68,0,29,0,209,0,36,0,110,0,0,0,129,0,0,0,86,0,144,0,155,0,224,0,130,0,0,0,177,0,205,0,0,0,0,0,240,0,122,0,99,0,204,0,10,0,0,0,124,0,115,0,202,0,223,0,232,0,53,0,23,0,146,0,218,0,253,0,135,0,149,0,42,0,169,0,2,0,61,0,236,0,69,0,0,0,15,0,249,0,244,0,0,0,178,0,138,0,0,0,0,0,42,0,0,0,150,0,0,0,193,0,0,0,29,0,0,0,127,0,221,0,106,0,29,0,76,0,237,0,46,0,5,0,75,0,89,0,250,0,50,0,201,0,41,0,7,0,87,0,106,0,14,0,0,0,26,0,130,0,129,0,221,0,139,0,219,0,185,0,0,0,218,0,55,0,136,0,31,0,43,0,224,0,118,0,151,0,0,0,106,0,0,0,157,0,164,0,242,0,130,0,232,0,168,0,255,0,30,0,0,0,35,0,147,0,102,0,0,0,186,0,120,0,0,0,116,0,128,0,253,0,0,0,244,0,38,0,232,0,141,0,114,0,255,0,0,0,115,0,149,0,130,0,0,0,0,0,177,0,102,0,75,0,73,0,0,0,167,0,36,0,118,0,78,0,28,0,183,0,41,0,27,0,25,0,0,0,130,0,0,0,148,0,75,0,0,0,216,0,133,0,115,0,129,0,113,0,62,0,33,0,212,0,92,0,0,0,92,0,212,0,152,0,116,0,0,0,224,0,103,0,115,0,0,0,154,0,148,0,5,0,187,0,9,0,12,0,0,0,0,0,181,0,50,0,0,0,161,0,242,0,160,0,0,0,253,0,0,0,192,0,0,0,115,0,148,0,166,0,0,0,183,0,176,0,0,0,0,0,171,0,0,0,0,0,210,0,41,0,0,0,159,0,123,0,0,0,0,0,203,0,233,0,0,0,0,0,233,0,35,0,212,0,197,0,0,0,56,0,240,0,103,0,13,0,41,0,213,0,0,0,204,0,65,0,169,0,136,0,164,0,0,0,185,0,7,0,13,0,245,0,170,0,88,0,112,0,50,0,186,0,57,0,24,0,216,0,0,0,175,0,166,0,0,0,40,0,80,0,103,0,239,0,159,0,228,0,208,0,179,0,146,0,83,0,0,0,0,0,60,0,0,0,27,0,0,0,0,0,226,0,127,0,250,0,146,0,121,0,72,0,98,0,18,0,143,0,0,0,105,0,122,0,102,0,1,0,252,0,238,0,0,0,146,0,0,0,10,0,82,0,0,0,75,0,25,0,0,0,0,0,0,0,0,0,6,0,40,0,214,0,155,0,255,0,67,0,177,0,21,0,125,0,26,0,108,0,0,0,178,0,119,0,32,0,169,0,84,0,47,0,141,0,82,0,116,0,36,0,93,0,25,0,247,0,0,0,65,0,110,0,132,0,121,0,74,0,162,0,10,0,0,0,50,0,0,0,0,0,168,0,103,0,201,0,27,0,64,0,173,0,0,0,107,0,63,0,0,0,0,0,117,0,0,0,188,0,92,0,52,0,58,0,171,0,0,0,150,0,182,0,135,0,120,0,81,0,0,0,0,0,85,0,159,0,167,0,239,0,244,0,54,0,139,0,97,0,117,0,59,0,169,0,223,0,0,0,48,0,0,0,26,0,242,0,0,0,117,0,0,0,0,0,0,0,0,0,83,0,188,0,0,0,193,0,142,0,88,0,123,0,82,0,126,0,29,0,0,0,93,0,74,0,133,0,0,0,250,0,181,0,130,0,121,0,0,0,172,0,176,0,150,0,0,0,10,0,52,0,0,0,164,0,199,0,177,0,152,0,0,0,0,0,86,0,90,0,232,0,140,0,68,0,0,0,144,0,35,0,69,0,0,0,230,0,223,0,159,0,22,0,4,0,69,0,223,0,0,0,184,0,194,0,0,0,0,0,0,0,34,0,185,0,174,0,254,0,230,0,49,0,185,0,161,0,126,0,38,0,71,0,177,0,194,0,0,0,32,0,99,0,128,0,164,0,0,0,167,0,37,0,141,0,247,0,116,0,79,0,154,0,44,0,99,0,156,0,139,0,173,0,122,0,0,0,163,0,127,0,242,0,244,0,182,0,133,0,152,0,63,0,166,0,123,0,90,0,64,0,91,0,0,0,219,0,168,0,135,0,236,0,115,0,211,0,0,0,59,0,133,0,244,0,0,0,132,0,182,0,165,0,197,0);
signal scenario_full  : scenario_type := (249,31,249,30,85,31,253,31,241,31,32,31,211,31,211,30,1,31,24,31,24,30,82,31,82,30,82,29,56,31,133,31,252,31,252,30,252,29,187,31,205,31,136,31,63,31,166,31,10,31,47,31,201,31,109,31,109,30,109,29,87,31,217,31,106,31,106,30,226,31,50,31,250,31,11,31,253,31,13,31,221,31,206,31,123,31,123,30,58,31,111,31,111,30,232,31,189,31,237,31,5,31,232,31,199,31,12,31,12,30,12,29,156,31,163,31,230,31,18,31,197,31,197,30,68,31,68,30,79,31,66,31,8,31,214,31,214,30,214,29,214,28,214,27,111,31,109,31,251,31,251,30,251,29,94,31,94,30,231,31,231,30,231,29,200,31,200,30,23,31,23,30,23,29,213,31,196,31,133,31,26,31,26,30,26,29,194,31,199,31,117,31,73,31,38,31,3,31,14,31,193,31,193,30,155,31,62,31,62,30,62,29,197,31,197,30,197,29,65,31,82,31,58,31,134,31,205,31,89,31,89,30,181,31,249,31,249,30,107,31,68,31,29,31,209,31,36,31,110,31,110,30,129,31,129,30,86,31,144,31,155,31,224,31,130,31,130,30,177,31,205,31,205,30,205,29,240,31,122,31,99,31,204,31,10,31,10,30,124,31,115,31,202,31,223,31,232,31,53,31,23,31,146,31,218,31,253,31,135,31,149,31,42,31,169,31,2,31,61,31,236,31,69,31,69,30,15,31,249,31,244,31,244,30,178,31,138,31,138,30,138,29,42,31,42,30,150,31,150,30,193,31,193,30,29,31,29,30,127,31,221,31,106,31,29,31,76,31,237,31,46,31,5,31,75,31,89,31,250,31,50,31,201,31,41,31,7,31,87,31,106,31,14,31,14,30,26,31,130,31,129,31,221,31,139,31,219,31,185,31,185,30,218,31,55,31,136,31,31,31,43,31,224,31,118,31,151,31,151,30,106,31,106,30,157,31,164,31,242,31,130,31,232,31,168,31,255,31,30,31,30,30,35,31,147,31,102,31,102,30,186,31,120,31,120,30,116,31,128,31,253,31,253,30,244,31,38,31,232,31,141,31,114,31,255,31,255,30,115,31,149,31,130,31,130,30,130,29,177,31,102,31,75,31,73,31,73,30,167,31,36,31,118,31,78,31,28,31,183,31,41,31,27,31,25,31,25,30,130,31,130,30,148,31,75,31,75,30,216,31,133,31,115,31,129,31,113,31,62,31,33,31,212,31,92,31,92,30,92,31,212,31,152,31,116,31,116,30,224,31,103,31,115,31,115,30,154,31,148,31,5,31,187,31,9,31,12,31,12,30,12,29,181,31,50,31,50,30,161,31,242,31,160,31,160,30,253,31,253,30,192,31,192,30,115,31,148,31,166,31,166,30,183,31,176,31,176,30,176,29,171,31,171,30,171,29,210,31,41,31,41,30,159,31,123,31,123,30,123,29,203,31,233,31,233,30,233,29,233,31,35,31,212,31,197,31,197,30,56,31,240,31,103,31,13,31,41,31,213,31,213,30,204,31,65,31,169,31,136,31,164,31,164,30,185,31,7,31,13,31,245,31,170,31,88,31,112,31,50,31,186,31,57,31,24,31,216,31,216,30,175,31,166,31,166,30,40,31,80,31,103,31,239,31,159,31,228,31,208,31,179,31,146,31,83,31,83,30,83,29,60,31,60,30,27,31,27,30,27,29,226,31,127,31,250,31,146,31,121,31,72,31,98,31,18,31,143,31,143,30,105,31,122,31,102,31,1,31,252,31,238,31,238,30,146,31,146,30,10,31,82,31,82,30,75,31,25,31,25,30,25,29,25,28,25,27,6,31,40,31,214,31,155,31,255,31,67,31,177,31,21,31,125,31,26,31,108,31,108,30,178,31,119,31,32,31,169,31,84,31,47,31,141,31,82,31,116,31,36,31,93,31,25,31,247,31,247,30,65,31,110,31,132,31,121,31,74,31,162,31,10,31,10,30,50,31,50,30,50,29,168,31,103,31,201,31,27,31,64,31,173,31,173,30,107,31,63,31,63,30,63,29,117,31,117,30,188,31,92,31,52,31,58,31,171,31,171,30,150,31,182,31,135,31,120,31,81,31,81,30,81,29,85,31,159,31,167,31,239,31,244,31,54,31,139,31,97,31,117,31,59,31,169,31,223,31,223,30,48,31,48,30,26,31,242,31,242,30,117,31,117,30,117,29,117,28,117,27,83,31,188,31,188,30,193,31,142,31,88,31,123,31,82,31,126,31,29,31,29,30,93,31,74,31,133,31,133,30,250,31,181,31,130,31,121,31,121,30,172,31,176,31,150,31,150,30,10,31,52,31,52,30,164,31,199,31,177,31,152,31,152,30,152,29,86,31,90,31,232,31,140,31,68,31,68,30,144,31,35,31,69,31,69,30,230,31,223,31,159,31,22,31,4,31,69,31,223,31,223,30,184,31,194,31,194,30,194,29,194,28,34,31,185,31,174,31,254,31,230,31,49,31,185,31,161,31,126,31,38,31,71,31,177,31,194,31,194,30,32,31,99,31,128,31,164,31,164,30,167,31,37,31,141,31,247,31,116,31,79,31,154,31,44,31,99,31,156,31,139,31,173,31,122,31,122,30,163,31,127,31,242,31,244,31,182,31,133,31,152,31,63,31,166,31,123,31,90,31,64,31,91,31,91,30,219,31,168,31,135,31,236,31,115,31,211,31,211,30,59,31,133,31,244,31,244,30,132,31,182,31,165,31,197,31);

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
