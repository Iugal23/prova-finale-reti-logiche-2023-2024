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

constant SCENARIO_LENGTH : integer := 324;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (175,0,17,0,36,0,0,0,136,0,255,0,174,0,0,0,83,0,242,0,63,0,249,0,0,0,112,0,223,0,159,0,149,0,13,0,114,0,0,0,92,0,0,0,31,0,214,0,10,0,212,0,0,0,53,0,0,0,93,0,128,0,165,0,0,0,31,0,159,0,57,0,77,0,166,0,38,0,6,0,0,0,106,0,157,0,50,0,0,0,6,0,115,0,23,0,199,0,0,0,0,0,0,0,174,0,3,0,41,0,0,0,9,0,64,0,103,0,210,0,166,0,203,0,202,0,110,0,157,0,73,0,189,0,136,0,225,0,144,0,240,0,22,0,109,0,6,0,247,0,209,0,9,0,0,0,0,0,0,0,252,0,220,0,130,0,163,0,145,0,254,0,0,0,114,0,118,0,226,0,41,0,36,0,134,0,0,0,86,0,59,0,94,0,86,0,0,0,23,0,195,0,0,0,115,0,31,0,221,0,218,0,0,0,226,0,116,0,0,0,84,0,105,0,0,0,0,0,24,0,134,0,166,0,0,0,0,0,12,0,66,0,168,0,233,0,199,0,143,0,177,0,0,0,219,0,0,0,6,0,203,0,137,0,67,0,54,0,165,0,238,0,156,0,214,0,153,0,0,0,104,0,126,0,250,0,240,0,182,0,126,0,0,0,0,0,0,0,139,0,117,0,61,0,0,0,0,0,15,0,66,0,157,0,0,0,0,0,59,0,60,0,50,0,157,0,117,0,0,0,59,0,0,0,242,0,205,0,66,0,192,0,183,0,65,0,41,0,119,0,145,0,153,0,0,0,108,0,0,0,120,0,103,0,0,0,215,0,0,0,0,0,0,0,6,0,0,0,0,0,75,0,211,0,0,0,35,0,4,0,186,0,251,0,0,0,243,0,118,0,164,0,191,0,237,0,45,0,98,0,0,0,227,0,131,0,185,0,0,0,144,0,1,0,247,0,46,0,244,0,0,0,165,0,0,0,13,0,208,0,153,0,232,0,186,0,0,0,81,0,135,0,0,0,0,0,234,0,97,0,0,0,79,0,146,0,205,0,184,0,95,0,226,0,91,0,18,0,118,0,192,0,196,0,99,0,218,0,172,0,211,0,192,0,153,0,0,0,156,0,0,0,253,0,158,0,93,0,176,0,78,0,0,0,22,0,0,0,132,0,117,0,171,0,225,0,147,0,202,0,242,0,131,0,0,0,57,0,152,0,0,0,236,0,0,0,50,0,206,0,184,0,2,0,69,0,54,0,171,0,142,0,77,0,0,0,156,0,34,0,132,0,0,0,85,0,0,0,0,0,123,0,206,0,134,0,0,0,0,0,100,0,45,0,166,0,142,0,0,0,0,0,75,0,101,0,0,0,255,0,253,0,102,0,0,0,39,0,65,0,233,0,0,0,145,0,0,0,87,0,110,0,204,0,251,0,0,0,150,0,93,0,153,0,228,0,192,0);
signal scenario_full  : scenario_type := (175,31,17,31,36,31,36,30,136,31,255,31,174,31,174,30,83,31,242,31,63,31,249,31,249,30,112,31,223,31,159,31,149,31,13,31,114,31,114,30,92,31,92,30,31,31,214,31,10,31,212,31,212,30,53,31,53,30,93,31,128,31,165,31,165,30,31,31,159,31,57,31,77,31,166,31,38,31,6,31,6,30,106,31,157,31,50,31,50,30,6,31,115,31,23,31,199,31,199,30,199,29,199,28,174,31,3,31,41,31,41,30,9,31,64,31,103,31,210,31,166,31,203,31,202,31,110,31,157,31,73,31,189,31,136,31,225,31,144,31,240,31,22,31,109,31,6,31,247,31,209,31,9,31,9,30,9,29,9,28,252,31,220,31,130,31,163,31,145,31,254,31,254,30,114,31,118,31,226,31,41,31,36,31,134,31,134,30,86,31,59,31,94,31,86,31,86,30,23,31,195,31,195,30,115,31,31,31,221,31,218,31,218,30,226,31,116,31,116,30,84,31,105,31,105,30,105,29,24,31,134,31,166,31,166,30,166,29,12,31,66,31,168,31,233,31,199,31,143,31,177,31,177,30,219,31,219,30,6,31,203,31,137,31,67,31,54,31,165,31,238,31,156,31,214,31,153,31,153,30,104,31,126,31,250,31,240,31,182,31,126,31,126,30,126,29,126,28,139,31,117,31,61,31,61,30,61,29,15,31,66,31,157,31,157,30,157,29,59,31,60,31,50,31,157,31,117,31,117,30,59,31,59,30,242,31,205,31,66,31,192,31,183,31,65,31,41,31,119,31,145,31,153,31,153,30,108,31,108,30,120,31,103,31,103,30,215,31,215,30,215,29,215,28,6,31,6,30,6,29,75,31,211,31,211,30,35,31,4,31,186,31,251,31,251,30,243,31,118,31,164,31,191,31,237,31,45,31,98,31,98,30,227,31,131,31,185,31,185,30,144,31,1,31,247,31,46,31,244,31,244,30,165,31,165,30,13,31,208,31,153,31,232,31,186,31,186,30,81,31,135,31,135,30,135,29,234,31,97,31,97,30,79,31,146,31,205,31,184,31,95,31,226,31,91,31,18,31,118,31,192,31,196,31,99,31,218,31,172,31,211,31,192,31,153,31,153,30,156,31,156,30,253,31,158,31,93,31,176,31,78,31,78,30,22,31,22,30,132,31,117,31,171,31,225,31,147,31,202,31,242,31,131,31,131,30,57,31,152,31,152,30,236,31,236,30,50,31,206,31,184,31,2,31,69,31,54,31,171,31,142,31,77,31,77,30,156,31,34,31,132,31,132,30,85,31,85,30,85,29,123,31,206,31,134,31,134,30,134,29,100,31,45,31,166,31,142,31,142,30,142,29,75,31,101,31,101,30,255,31,253,31,102,31,102,30,39,31,65,31,233,31,233,30,145,31,145,30,87,31,110,31,204,31,251,31,251,30,150,31,93,31,153,31,228,31,192,31);

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
