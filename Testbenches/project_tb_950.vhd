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

constant SCENARIO_LENGTH : integer := 480;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (88,0,79,0,0,0,133,0,219,0,221,0,188,0,46,0,114,0,144,0,3,0,0,0,244,0,243,0,75,0,91,0,33,0,59,0,63,0,0,0,0,0,14,0,25,0,218,0,237,0,237,0,191,0,131,0,45,0,218,0,144,0,229,0,90,0,132,0,195,0,183,0,0,0,75,0,51,0,65,0,143,0,124,0,212,0,8,0,179,0,174,0,0,0,205,0,0,0,28,0,235,0,0,0,151,0,0,0,0,0,164,0,249,0,133,0,10,0,0,0,239,0,94,0,19,0,160,0,163,0,55,0,173,0,163,0,233,0,158,0,176,0,136,0,190,0,0,0,151,0,117,0,82,0,0,0,184,0,0,0,137,0,0,0,80,0,198,0,177,0,96,0,199,0,181,0,0,0,0,0,209,0,149,0,237,0,190,0,0,0,0,0,81,0,178,0,0,0,0,0,135,0,105,0,246,0,198,0,245,0,175,0,237,0,0,0,160,0,142,0,181,0,0,0,134,0,92,0,191,0,52,0,237,0,64,0,46,0,0,0,64,0,69,0,146,0,171,0,174,0,250,0,0,0,0,0,33,0,102,0,87,0,41,0,18,0,105,0,0,0,176,0,89,0,154,0,221,0,183,0,16,0,0,0,18,0,151,0,213,0,66,0,124,0,119,0,84,0,232,0,191,0,52,0,118,0,194,0,13,0,0,0,176,0,0,0,0,0,255,0,92,0,42,0,0,0,240,0,84,0,186,0,27,0,110,0,166,0,63,0,92,0,0,0,193,0,0,0,149,0,0,0,202,0,138,0,12,0,0,0,201,0,0,0,5,0,63,0,241,0,136,0,0,0,0,0,194,0,203,0,125,0,245,0,53,0,228,0,111,0,24,0,1,0,230,0,0,0,0,0,131,0,39,0,83,0,243,0,0,0,253,0,254,0,0,0,196,0,87,0,0,0,11,0,160,0,134,0,98,0,155,0,0,0,0,0,236,0,174,0,28,0,5,0,49,0,178,0,252,0,0,0,0,0,73,0,234,0,142,0,0,0,170,0,20,0,107,0,91,0,154,0,0,0,180,0,9,0,159,0,121,0,0,0,102,0,112,0,175,0,225,0,0,0,209,0,0,0,106,0,32,0,86,0,138,0,160,0,230,0,234,0,0,0,38,0,62,0,0,0,91,0,58,0,0,0,56,0,193,0,207,0,110,0,165,0,0,0,95,0,0,0,221,0,209,0,0,0,29,0,0,0,0,0,248,0,128,0,197,0,0,0,40,0,94,0,233,0,0,0,79,0,112,0,57,0,34,0,215,0,4,0,23,0,233,0,37,0,136,0,210,0,243,0,159,0,63,0,42,0,0,0,223,0,213,0,96,0,0,0,80,0,144,0,0,0,68,0,43,0,8,0,227,0,37,0,0,0,0,0,188,0,190,0,0,0,0,0,167,0,6,0,36,0,77,0,0,0,117,0,0,0,251,0,149,0,0,0,0,0,141,0,0,0,185,0,147,0,46,0,60,0,0,0,223,0,21,0,197,0,0,0,157,0,97,0,76,0,158,0,209,0,45,0,144,0,226,0,0,0,219,0,112,0,184,0,145,0,230,0,136,0,45,0,96,0,0,0,255,0,6,0,90,0,1,0,65,0,79,0,229,0,194,0,23,0,16,0,125,0,109,0,0,0,126,0,148,0,42,0,5,0,249,0,141,0,0,0,158,0,143,0,192,0,0,0,48,0,0,0,97,0,105,0,84,0,218,0,189,0,201,0,96,0,38,0,200,0,95,0,241,0,0,0,200,0,0,0,0,0,224,0,203,0,0,0,164,0,13,0,220,0,201,0,0,0,210,0,21,0,238,0,32,0,100,0,179,0,169,0,0,0,26,0,163,0,67,0,0,0,148,0,5,0,140,0,115,0,136,0,0,0,229,0,17,0,0,0,79,0,0,0,194,0,45,0,170,0,0,0,138,0,0,0,127,0,223,0,242,0,21,0,83,0,162,0,92,0,224,0,109,0,134,0,203,0,0,0,79,0,169,0,45,0,196,0,0,0,3,0,66,0,69,0,231,0,35,0,151,0,193,0,57,0,120,0,0,0,0,0,132,0,94,0,0,0,20,0,142,0,221,0,55,0,161,0,215,0,172,0,20,0,58,0,0,0,0,0,54,0);
signal scenario_full  : scenario_type := (88,31,79,31,79,30,133,31,219,31,221,31,188,31,46,31,114,31,144,31,3,31,3,30,244,31,243,31,75,31,91,31,33,31,59,31,63,31,63,30,63,29,14,31,25,31,218,31,237,31,237,31,191,31,131,31,45,31,218,31,144,31,229,31,90,31,132,31,195,31,183,31,183,30,75,31,51,31,65,31,143,31,124,31,212,31,8,31,179,31,174,31,174,30,205,31,205,30,28,31,235,31,235,30,151,31,151,30,151,29,164,31,249,31,133,31,10,31,10,30,239,31,94,31,19,31,160,31,163,31,55,31,173,31,163,31,233,31,158,31,176,31,136,31,190,31,190,30,151,31,117,31,82,31,82,30,184,31,184,30,137,31,137,30,80,31,198,31,177,31,96,31,199,31,181,31,181,30,181,29,209,31,149,31,237,31,190,31,190,30,190,29,81,31,178,31,178,30,178,29,135,31,105,31,246,31,198,31,245,31,175,31,237,31,237,30,160,31,142,31,181,31,181,30,134,31,92,31,191,31,52,31,237,31,64,31,46,31,46,30,64,31,69,31,146,31,171,31,174,31,250,31,250,30,250,29,33,31,102,31,87,31,41,31,18,31,105,31,105,30,176,31,89,31,154,31,221,31,183,31,16,31,16,30,18,31,151,31,213,31,66,31,124,31,119,31,84,31,232,31,191,31,52,31,118,31,194,31,13,31,13,30,176,31,176,30,176,29,255,31,92,31,42,31,42,30,240,31,84,31,186,31,27,31,110,31,166,31,63,31,92,31,92,30,193,31,193,30,149,31,149,30,202,31,138,31,12,31,12,30,201,31,201,30,5,31,63,31,241,31,136,31,136,30,136,29,194,31,203,31,125,31,245,31,53,31,228,31,111,31,24,31,1,31,230,31,230,30,230,29,131,31,39,31,83,31,243,31,243,30,253,31,254,31,254,30,196,31,87,31,87,30,11,31,160,31,134,31,98,31,155,31,155,30,155,29,236,31,174,31,28,31,5,31,49,31,178,31,252,31,252,30,252,29,73,31,234,31,142,31,142,30,170,31,20,31,107,31,91,31,154,31,154,30,180,31,9,31,159,31,121,31,121,30,102,31,112,31,175,31,225,31,225,30,209,31,209,30,106,31,32,31,86,31,138,31,160,31,230,31,234,31,234,30,38,31,62,31,62,30,91,31,58,31,58,30,56,31,193,31,207,31,110,31,165,31,165,30,95,31,95,30,221,31,209,31,209,30,29,31,29,30,29,29,248,31,128,31,197,31,197,30,40,31,94,31,233,31,233,30,79,31,112,31,57,31,34,31,215,31,4,31,23,31,233,31,37,31,136,31,210,31,243,31,159,31,63,31,42,31,42,30,223,31,213,31,96,31,96,30,80,31,144,31,144,30,68,31,43,31,8,31,227,31,37,31,37,30,37,29,188,31,190,31,190,30,190,29,167,31,6,31,36,31,77,31,77,30,117,31,117,30,251,31,149,31,149,30,149,29,141,31,141,30,185,31,147,31,46,31,60,31,60,30,223,31,21,31,197,31,197,30,157,31,97,31,76,31,158,31,209,31,45,31,144,31,226,31,226,30,219,31,112,31,184,31,145,31,230,31,136,31,45,31,96,31,96,30,255,31,6,31,90,31,1,31,65,31,79,31,229,31,194,31,23,31,16,31,125,31,109,31,109,30,126,31,148,31,42,31,5,31,249,31,141,31,141,30,158,31,143,31,192,31,192,30,48,31,48,30,97,31,105,31,84,31,218,31,189,31,201,31,96,31,38,31,200,31,95,31,241,31,241,30,200,31,200,30,200,29,224,31,203,31,203,30,164,31,13,31,220,31,201,31,201,30,210,31,21,31,238,31,32,31,100,31,179,31,169,31,169,30,26,31,163,31,67,31,67,30,148,31,5,31,140,31,115,31,136,31,136,30,229,31,17,31,17,30,79,31,79,30,194,31,45,31,170,31,170,30,138,31,138,30,127,31,223,31,242,31,21,31,83,31,162,31,92,31,224,31,109,31,134,31,203,31,203,30,79,31,169,31,45,31,196,31,196,30,3,31,66,31,69,31,231,31,35,31,151,31,193,31,57,31,120,31,120,30,120,29,132,31,94,31,94,30,20,31,142,31,221,31,55,31,161,31,215,31,172,31,20,31,58,31,58,30,58,29,54,31);

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
