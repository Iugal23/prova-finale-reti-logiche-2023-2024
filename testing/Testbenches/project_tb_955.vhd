-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_955 is
end project_tb_955;

architecture project_tb_arch_955 of project_tb_955 is
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

constant SCENARIO_LENGTH : integer := 477;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (1,0,237,0,23,0,206,0,7,0,129,0,240,0,169,0,46,0,0,0,113,0,88,0,0,0,0,0,117,0,206,0,96,0,174,0,235,0,202,0,0,0,43,0,0,0,161,0,26,0,20,0,111,0,84,0,159,0,0,0,0,0,0,0,0,0,58,0,31,0,78,0,0,0,4,0,5,0,0,0,150,0,127,0,76,0,232,0,146,0,127,0,227,0,43,0,33,0,249,0,241,0,173,0,0,0,193,0,0,0,0,0,216,0,63,0,132,0,122,0,128,0,0,0,71,0,72,0,113,0,173,0,0,0,38,0,54,0,4,0,82,0,31,0,166,0,0,0,57,0,129,0,245,0,117,0,157,0,143,0,126,0,0,0,78,0,127,0,118,0,130,0,241,0,134,0,196,0,37,0,112,0,110,0,55,0,250,0,75,0,206,0,124,0,78,0,37,0,161,0,0,0,132,0,151,0,165,0,41,0,118,0,149,0,134,0,103,0,154,0,54,0,74,0,125,0,1,0,0,0,118,0,190,0,71,0,0,0,184,0,77,0,0,0,161,0,3,0,49,0,162,0,49,0,0,0,38,0,0,0,254,0,0,0,161,0,63,0,230,0,0,0,114,0,112,0,42,0,202,0,0,0,0,0,0,0,182,0,0,0,183,0,0,0,164,0,54,0,0,0,20,0,117,0,215,0,146,0,0,0,151,0,0,0,128,0,0,0,64,0,0,0,0,0,0,0,143,0,243,0,190,0,70,0,183,0,118,0,146,0,133,0,221,0,42,0,150,0,137,0,76,0,159,0,0,0,97,0,62,0,63,0,80,0,212,0,232,0,21,0,180,0,7,0,197,0,0,0,77,0,199,0,98,0,183,0,117,0,211,0,35,0,172,0,134,0,108,0,49,0,154,0,25,0,197,0,0,0,224,0,33,0,248,0,141,0,52,0,0,0,199,0,203,0,0,0,24,0,46,0,0,0,121,0,174,0,116,0,194,0,0,0,127,0,0,0,206,0,122,0,0,0,187,0,210,0,230,0,0,0,209,0,0,0,230,0,10,0,151,0,0,0,0,0,92,0,206,0,141,0,74,0,251,0,82,0,0,0,22,0,243,0,143,0,119,0,240,0,162,0,242,0,0,0,212,0,223,0,0,0,186,0,0,0,137,0,57,0,239,0,213,0,255,0,0,0,130,0,145,0,80,0,205,0,0,0,176,0,50,0,83,0,103,0,56,0,147,0,223,0,36,0,205,0,209,0,136,0,128,0,14,0,0,0,213,0,0,0,199,0,6,0,196,0,63,0,177,0,129,0,0,0,248,0,0,0,172,0,248,0,178,0,0,0,244,0,59,0,25,0,103,0,241,0,216,0,27,0,155,0,155,0,0,0,210,0,0,0,105,0,156,0,46,0,230,0,114,0,0,0,73,0,0,0,123,0,253,0,152,0,204,0,167,0,165,0,133,0,194,0,0,0,0,0,227,0,38,0,95,0,213,0,86,0,179,0,246,0,12,0,227,0,38,0,39,0,26,0,146,0,161,0,118,0,0,0,37,0,166,0,0,0,0,0,0,0,45,0,20,0,0,0,187,0,0,0,0,0,224,0,129,0,7,0,63,0,10,0,165,0,60,0,0,0,247,0,73,0,172,0,0,0,203,0,110,0,155,0,144,0,71,0,98,0,182,0,19,0,202,0,185,0,2,0,30,0,178,0,199,0,159,0,206,0,229,0,255,0,144,0,247,0,8,0,234,0,93,0,178,0,69,0,1,0,85,0,172,0,0,0,135,0,8,0,185,0,0,0,72,0,201,0,55,0,0,0,172,0,0,0,0,0,0,0,206,0,0,0,0,0,255,0,93,0,138,0,160,0,143,0,107,0,210,0,86,0,0,0,60,0,137,0,0,0,0,0,0,0,85,0,253,0,0,0,143,0,0,0,159,0,139,0,4,0,0,0,61,0,110,0,147,0,87,0,0,0,224,0,29,0,140,0,0,0,0,0,184,0,119,0,86,0,253,0,254,0,229,0,224,0,196,0,255,0,147,0,67,0,27,0,170,0,135,0,187,0,13,0,52,0,195,0,229,0,211,0,0,0,228,0,44,0,143,0,184,0,0,0,149,0,62,0,22,0,64,0,0,0,0,0,97,0,23,0);
signal scenario_full  : scenario_type := (1,31,237,31,23,31,206,31,7,31,129,31,240,31,169,31,46,31,46,30,113,31,88,31,88,30,88,29,117,31,206,31,96,31,174,31,235,31,202,31,202,30,43,31,43,30,161,31,26,31,20,31,111,31,84,31,159,31,159,30,159,29,159,28,159,27,58,31,31,31,78,31,78,30,4,31,5,31,5,30,150,31,127,31,76,31,232,31,146,31,127,31,227,31,43,31,33,31,249,31,241,31,173,31,173,30,193,31,193,30,193,29,216,31,63,31,132,31,122,31,128,31,128,30,71,31,72,31,113,31,173,31,173,30,38,31,54,31,4,31,82,31,31,31,166,31,166,30,57,31,129,31,245,31,117,31,157,31,143,31,126,31,126,30,78,31,127,31,118,31,130,31,241,31,134,31,196,31,37,31,112,31,110,31,55,31,250,31,75,31,206,31,124,31,78,31,37,31,161,31,161,30,132,31,151,31,165,31,41,31,118,31,149,31,134,31,103,31,154,31,54,31,74,31,125,31,1,31,1,30,118,31,190,31,71,31,71,30,184,31,77,31,77,30,161,31,3,31,49,31,162,31,49,31,49,30,38,31,38,30,254,31,254,30,161,31,63,31,230,31,230,30,114,31,112,31,42,31,202,31,202,30,202,29,202,28,182,31,182,30,183,31,183,30,164,31,54,31,54,30,20,31,117,31,215,31,146,31,146,30,151,31,151,30,128,31,128,30,64,31,64,30,64,29,64,28,143,31,243,31,190,31,70,31,183,31,118,31,146,31,133,31,221,31,42,31,150,31,137,31,76,31,159,31,159,30,97,31,62,31,63,31,80,31,212,31,232,31,21,31,180,31,7,31,197,31,197,30,77,31,199,31,98,31,183,31,117,31,211,31,35,31,172,31,134,31,108,31,49,31,154,31,25,31,197,31,197,30,224,31,33,31,248,31,141,31,52,31,52,30,199,31,203,31,203,30,24,31,46,31,46,30,121,31,174,31,116,31,194,31,194,30,127,31,127,30,206,31,122,31,122,30,187,31,210,31,230,31,230,30,209,31,209,30,230,31,10,31,151,31,151,30,151,29,92,31,206,31,141,31,74,31,251,31,82,31,82,30,22,31,243,31,143,31,119,31,240,31,162,31,242,31,242,30,212,31,223,31,223,30,186,31,186,30,137,31,57,31,239,31,213,31,255,31,255,30,130,31,145,31,80,31,205,31,205,30,176,31,50,31,83,31,103,31,56,31,147,31,223,31,36,31,205,31,209,31,136,31,128,31,14,31,14,30,213,31,213,30,199,31,6,31,196,31,63,31,177,31,129,31,129,30,248,31,248,30,172,31,248,31,178,31,178,30,244,31,59,31,25,31,103,31,241,31,216,31,27,31,155,31,155,31,155,30,210,31,210,30,105,31,156,31,46,31,230,31,114,31,114,30,73,31,73,30,123,31,253,31,152,31,204,31,167,31,165,31,133,31,194,31,194,30,194,29,227,31,38,31,95,31,213,31,86,31,179,31,246,31,12,31,227,31,38,31,39,31,26,31,146,31,161,31,118,31,118,30,37,31,166,31,166,30,166,29,166,28,45,31,20,31,20,30,187,31,187,30,187,29,224,31,129,31,7,31,63,31,10,31,165,31,60,31,60,30,247,31,73,31,172,31,172,30,203,31,110,31,155,31,144,31,71,31,98,31,182,31,19,31,202,31,185,31,2,31,30,31,178,31,199,31,159,31,206,31,229,31,255,31,144,31,247,31,8,31,234,31,93,31,178,31,69,31,1,31,85,31,172,31,172,30,135,31,8,31,185,31,185,30,72,31,201,31,55,31,55,30,172,31,172,30,172,29,172,28,206,31,206,30,206,29,255,31,93,31,138,31,160,31,143,31,107,31,210,31,86,31,86,30,60,31,137,31,137,30,137,29,137,28,85,31,253,31,253,30,143,31,143,30,159,31,139,31,4,31,4,30,61,31,110,31,147,31,87,31,87,30,224,31,29,31,140,31,140,30,140,29,184,31,119,31,86,31,253,31,254,31,229,31,224,31,196,31,255,31,147,31,67,31,27,31,170,31,135,31,187,31,13,31,52,31,195,31,229,31,211,31,211,30,228,31,44,31,143,31,184,31,184,30,149,31,62,31,22,31,64,31,64,30,64,29,97,31,23,31);

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
