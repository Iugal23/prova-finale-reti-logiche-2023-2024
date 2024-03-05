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

constant SCENARIO_LENGTH : integer := 572;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (158,0,99,0,33,0,0,0,210,0,76,0,216,0,152,0,0,0,126,0,174,0,43,0,163,0,57,0,0,0,212,0,0,0,148,0,59,0,115,0,129,0,0,0,106,0,203,0,74,0,118,0,0,0,191,0,41,0,141,0,72,0,0,0,239,0,56,0,164,0,253,0,0,0,0,0,101,0,150,0,58,0,0,0,57,0,37,0,206,0,190,0,0,0,84,0,0,0,239,0,0,0,171,0,151,0,158,0,255,0,121,0,23,0,29,0,112,0,0,0,240,0,0,0,123,0,131,0,165,0,0,0,31,0,156,0,53,0,178,0,20,0,0,0,0,0,253,0,211,0,44,0,191,0,249,0,58,0,152,0,212,0,32,0,185,0,163,0,136,0,150,0,0,0,61,0,204,0,0,0,0,0,142,0,187,0,143,0,48,0,226,0,250,0,187,0,7,0,246,0,116,0,146,0,0,0,166,0,0,0,149,0,216,0,15,0,245,0,194,0,0,0,74,0,204,0,69,0,161,0,24,0,254,0,0,0,11,0,173,0,202,0,91,0,75,0,164,0,0,0,234,0,100,0,36,0,197,0,72,0,148,0,0,0,203,0,0,0,197,0,0,0,124,0,62,0,102,0,101,0,137,0,206,0,194,0,0,0,209,0,77,0,116,0,240,0,42,0,125,0,246,0,153,0,199,0,197,0,0,0,168,0,200,0,96,0,251,0,223,0,0,0,0,0,0,0,89,0,1,0,184,0,152,0,212,0,90,0,211,0,200,0,0,0,61,0,26,0,0,0,222,0,70,0,137,0,82,0,90,0,228,0,0,0,0,0,99,0,0,0,0,0,196,0,249,0,73,0,98,0,87,0,27,0,59,0,110,0,75,0,30,0,181,0,0,0,0,0,227,0,0,0,49,0,140,0,29,0,0,0,61,0,36,0,208,0,242,0,185,0,203,0,195,0,81,0,18,0,42,0,31,0,172,0,247,0,65,0,200,0,216,0,149,0,204,0,0,0,231,0,236,0,0,0,235,0,153,0,31,0,0,0,169,0,0,0,110,0,198,0,0,0,90,0,154,0,123,0,0,0,133,0,0,0,1,0,235,0,0,0,223,0,206,0,158,0,7,0,199,0,190,0,171,0,0,0,121,0,0,0,69,0,174,0,0,0,249,0,47,0,153,0,125,0,0,0,148,0,0,0,172,0,87,0,131,0,0,0,96,0,249,0,78,0,0,0,151,0,144,0,226,0,250,0,51,0,61,0,242,0,16,0,151,0,17,0,122,0,121,0,0,0,41,0,226,0,6,0,77,0,196,0,237,0,39,0,52,0,0,0,0,0,120,0,236,0,152,0,59,0,91,0,0,0,69,0,56,0,72,0,74,0,86,0,121,0,0,0,115,0,91,0,90,0,245,0,105,0,50,0,193,0,18,0,3,0,148,0,128,0,164,0,28,0,130,0,48,0,34,0,129,0,182,0,132,0,41,0,0,0,0,0,42,0,189,0,244,0,197,0,202,0,206,0,158,0,255,0,27,0,0,0,0,0,66,0,233,0,80,0,214,0,95,0,72,0,3,0,184,0,175,0,254,0,0,0,182,0,150,0,137,0,211,0,42,0,157,0,0,0,77,0,119,0,57,0,10,0,80,0,0,0,225,0,194,0,0,0,220,0,0,0,0,0,0,0,245,0,0,0,101,0,245,0,0,0,158,0,211,0,0,0,181,0,154,0,246,0,61,0,59,0,126,0,0,0,44,0,30,0,11,0,0,0,91,0,0,0,89,0,0,0,0,0,52,0,143,0,218,0,140,0,47,0,0,0,28,0,22,0,105,0,0,0,235,0,56,0,185,0,59,0,2,0,0,0,229,0,146,0,0,0,0,0,22,0,51,0,0,0,0,0,0,0,232,0,222,0,0,0,0,0,80,0,13,0,230,0,160,0,137,0,247,0,59,0,50,0,219,0,11,0,168,0,89,0,255,0,17,0,247,0,0,0,0,0,21,0,48,0,85,0,55,0,188,0,0,0,110,0,121,0,241,0,19,0,153,0,62,0,40,0,161,0,228,0,80,0,0,0,217,0,219,0,253,0,10,0,234,0,241,0,245,0,0,0,88,0,0,0,0,0,43,0,0,0,246,0,192,0,205,0,0,0,105,0,0,0,0,0,41,0,3,0,0,0,113,0,177,0,94,0,20,0,221,0,157,0,107,0,221,0,53,0,0,0,247,0,164,0,243,0,0,0,173,0,180,0,0,0,223,0,110,0,175,0,152,0,0,0,114,0,86,0,83,0,0,0,164,0,179,0,188,0,16,0,56,0,247,0,4,0,29,0,0,0,0,0,148,0,95,0,224,0,170,0,183,0,51,0,87,0,180,0,66,0,148,0,229,0,122,0,12,0,0,0,0,0,0,0,17,0,28,0,124,0,223,0,244,0,107,0,235,0,0,0,0,0,221,0,105,0,123,0,149,0,40,0,34,0,221,0,124,0,69,0,64,0,0,0,8,0,39,0,0,0,81,0,176,0,225,0,179,0,144,0,0,0,170,0,0,0,177,0,33,0,4,0,181,0,64,0,44,0);
signal scenario_full  : scenario_type := (158,31,99,31,33,31,33,30,210,31,76,31,216,31,152,31,152,30,126,31,174,31,43,31,163,31,57,31,57,30,212,31,212,30,148,31,59,31,115,31,129,31,129,30,106,31,203,31,74,31,118,31,118,30,191,31,41,31,141,31,72,31,72,30,239,31,56,31,164,31,253,31,253,30,253,29,101,31,150,31,58,31,58,30,57,31,37,31,206,31,190,31,190,30,84,31,84,30,239,31,239,30,171,31,151,31,158,31,255,31,121,31,23,31,29,31,112,31,112,30,240,31,240,30,123,31,131,31,165,31,165,30,31,31,156,31,53,31,178,31,20,31,20,30,20,29,253,31,211,31,44,31,191,31,249,31,58,31,152,31,212,31,32,31,185,31,163,31,136,31,150,31,150,30,61,31,204,31,204,30,204,29,142,31,187,31,143,31,48,31,226,31,250,31,187,31,7,31,246,31,116,31,146,31,146,30,166,31,166,30,149,31,216,31,15,31,245,31,194,31,194,30,74,31,204,31,69,31,161,31,24,31,254,31,254,30,11,31,173,31,202,31,91,31,75,31,164,31,164,30,234,31,100,31,36,31,197,31,72,31,148,31,148,30,203,31,203,30,197,31,197,30,124,31,62,31,102,31,101,31,137,31,206,31,194,31,194,30,209,31,77,31,116,31,240,31,42,31,125,31,246,31,153,31,199,31,197,31,197,30,168,31,200,31,96,31,251,31,223,31,223,30,223,29,223,28,89,31,1,31,184,31,152,31,212,31,90,31,211,31,200,31,200,30,61,31,26,31,26,30,222,31,70,31,137,31,82,31,90,31,228,31,228,30,228,29,99,31,99,30,99,29,196,31,249,31,73,31,98,31,87,31,27,31,59,31,110,31,75,31,30,31,181,31,181,30,181,29,227,31,227,30,49,31,140,31,29,31,29,30,61,31,36,31,208,31,242,31,185,31,203,31,195,31,81,31,18,31,42,31,31,31,172,31,247,31,65,31,200,31,216,31,149,31,204,31,204,30,231,31,236,31,236,30,235,31,153,31,31,31,31,30,169,31,169,30,110,31,198,31,198,30,90,31,154,31,123,31,123,30,133,31,133,30,1,31,235,31,235,30,223,31,206,31,158,31,7,31,199,31,190,31,171,31,171,30,121,31,121,30,69,31,174,31,174,30,249,31,47,31,153,31,125,31,125,30,148,31,148,30,172,31,87,31,131,31,131,30,96,31,249,31,78,31,78,30,151,31,144,31,226,31,250,31,51,31,61,31,242,31,16,31,151,31,17,31,122,31,121,31,121,30,41,31,226,31,6,31,77,31,196,31,237,31,39,31,52,31,52,30,52,29,120,31,236,31,152,31,59,31,91,31,91,30,69,31,56,31,72,31,74,31,86,31,121,31,121,30,115,31,91,31,90,31,245,31,105,31,50,31,193,31,18,31,3,31,148,31,128,31,164,31,28,31,130,31,48,31,34,31,129,31,182,31,132,31,41,31,41,30,41,29,42,31,189,31,244,31,197,31,202,31,206,31,158,31,255,31,27,31,27,30,27,29,66,31,233,31,80,31,214,31,95,31,72,31,3,31,184,31,175,31,254,31,254,30,182,31,150,31,137,31,211,31,42,31,157,31,157,30,77,31,119,31,57,31,10,31,80,31,80,30,225,31,194,31,194,30,220,31,220,30,220,29,220,28,245,31,245,30,101,31,245,31,245,30,158,31,211,31,211,30,181,31,154,31,246,31,61,31,59,31,126,31,126,30,44,31,30,31,11,31,11,30,91,31,91,30,89,31,89,30,89,29,52,31,143,31,218,31,140,31,47,31,47,30,28,31,22,31,105,31,105,30,235,31,56,31,185,31,59,31,2,31,2,30,229,31,146,31,146,30,146,29,22,31,51,31,51,30,51,29,51,28,232,31,222,31,222,30,222,29,80,31,13,31,230,31,160,31,137,31,247,31,59,31,50,31,219,31,11,31,168,31,89,31,255,31,17,31,247,31,247,30,247,29,21,31,48,31,85,31,55,31,188,31,188,30,110,31,121,31,241,31,19,31,153,31,62,31,40,31,161,31,228,31,80,31,80,30,217,31,219,31,253,31,10,31,234,31,241,31,245,31,245,30,88,31,88,30,88,29,43,31,43,30,246,31,192,31,205,31,205,30,105,31,105,30,105,29,41,31,3,31,3,30,113,31,177,31,94,31,20,31,221,31,157,31,107,31,221,31,53,31,53,30,247,31,164,31,243,31,243,30,173,31,180,31,180,30,223,31,110,31,175,31,152,31,152,30,114,31,86,31,83,31,83,30,164,31,179,31,188,31,16,31,56,31,247,31,4,31,29,31,29,30,29,29,148,31,95,31,224,31,170,31,183,31,51,31,87,31,180,31,66,31,148,31,229,31,122,31,12,31,12,30,12,29,12,28,17,31,28,31,124,31,223,31,244,31,107,31,235,31,235,30,235,29,221,31,105,31,123,31,149,31,40,31,34,31,221,31,124,31,69,31,64,31,64,30,8,31,39,31,39,30,81,31,176,31,225,31,179,31,144,31,144,30,170,31,170,30,177,31,33,31,4,31,181,31,64,31,44,31);

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
