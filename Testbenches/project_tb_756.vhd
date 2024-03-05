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

constant SCENARIO_LENGTH : integer := 429;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (172,0,134,0,232,0,88,0,45,0,134,0,243,0,153,0,38,0,233,0,0,0,144,0,157,0,24,0,0,0,211,0,226,0,108,0,45,0,110,0,193,0,101,0,45,0,181,0,120,0,245,0,168,0,10,0,0,0,54,0,73,0,0,0,137,0,75,0,146,0,177,0,133,0,0,0,17,0,0,0,62,0,0,0,25,0,27,0,137,0,0,0,11,0,48,0,65,0,24,0,0,0,142,0,115,0,81,0,158,0,0,0,229,0,0,0,96,0,251,0,0,0,145,0,143,0,73,0,171,0,129,0,136,0,9,0,65,0,55,0,210,0,36,0,132,0,227,0,0,0,63,0,9,0,210,0,204,0,103,0,0,0,96,0,1,0,115,0,223,0,213,0,104,0,150,0,163,0,0,0,51,0,6,0,176,0,5,0,208,0,249,0,19,0,254,0,152,0,238,0,235,0,198,0,132,0,101,0,172,0,0,0,237,0,12,0,0,0,130,0,83,0,173,0,0,0,0,0,22,0,0,0,219,0,148,0,45,0,224,0,0,0,23,0,0,0,183,0,130,0,12,0,166,0,3,0,78,0,3,0,14,0,0,0,171,0,154,0,155,0,161,0,66,0,212,0,0,0,73,0,0,0,251,0,0,0,190,0,88,0,61,0,0,0,0,0,248,0,190,0,0,0,0,0,121,0,147,0,206,0,103,0,150,0,0,0,191,0,20,0,118,0,106,0,195,0,60,0,171,0,139,0,0,0,0,0,203,0,126,0,18,0,254,0,8,0,248,0,0,0,202,0,48,0,0,0,44,0,100,0,0,0,0,0,0,0,209,0,0,0,190,0,242,0,59,0,200,0,149,0,222,0,3,0,202,0,98,0,187,0,197,0,0,0,124,0,212,0,167,0,138,0,178,0,126,0,129,0,217,0,70,0,86,0,6,0,184,0,0,0,88,0,79,0,70,0,56,0,144,0,201,0,28,0,95,0,182,0,93,0,98,0,78,0,193,0,154,0,40,0,0,0,155,0,38,0,110,0,0,0,0,0,235,0,67,0,0,0,0,0,22,0,17,0,0,0,0,0,152,0,176,0,179,0,3,0,89,0,105,0,0,0,105,0,138,0,107,0,250,0,0,0,93,0,47,0,0,0,159,0,0,0,119,0,48,0,78,0,0,0,0,0,0,0,173,0,0,0,136,0,18,0,0,0,0,0,53,0,129,0,224,0,0,0,52,0,152,0,124,0,170,0,1,0,15,0,112,0,254,0,88,0,245,0,197,0,208,0,184,0,220,0,253,0,167,0,103,0,199,0,177,0,229,0,226,0,39,0,9,0,49,0,8,0,0,0,225,0,28,0,0,0,21,0,0,0,0,0,103,0,0,0,10,0,73,0,166,0,143,0,51,0,138,0,5,0,43,0,16,0,111,0,5,0,167,0,56,0,0,0,242,0,106,0,210,0,106,0,0,0,195,0,0,0,180,0,66,0,105,0,46,0,207,0,83,0,0,0,0,0,138,0,219,0,38,0,246,0,30,0,240,0,0,0,49,0,47,0,225,0,54,0,76,0,241,0,0,0,0,0,88,0,0,0,67,0,39,0,0,0,255,0,162,0,77,0,0,0,0,0,0,0,228,0,175,0,79,0,0,0,146,0,222,0,145,0,0,0,0,0,180,0,0,0,0,0,90,0,246,0,0,0,74,0,251,0,0,0,0,0,193,0,206,0,17,0,141,0,239,0,70,0,159,0,185,0,236,0,16,0,214,0,46,0,0,0,123,0,118,0,117,0,65,0,47,0,233,0,139,0,186,0,94,0,173,0,0,0,0,0,25,0,121,0,186,0,0,0,186,0,52,0,123,0,240,0,107,0,39,0,170,0,0,0,35,0,166,0,11,0,59,0,0,0,0,0,238,0,172,0,0,0,60,0,201,0,217,0);
signal scenario_full  : scenario_type := (172,31,134,31,232,31,88,31,45,31,134,31,243,31,153,31,38,31,233,31,233,30,144,31,157,31,24,31,24,30,211,31,226,31,108,31,45,31,110,31,193,31,101,31,45,31,181,31,120,31,245,31,168,31,10,31,10,30,54,31,73,31,73,30,137,31,75,31,146,31,177,31,133,31,133,30,17,31,17,30,62,31,62,30,25,31,27,31,137,31,137,30,11,31,48,31,65,31,24,31,24,30,142,31,115,31,81,31,158,31,158,30,229,31,229,30,96,31,251,31,251,30,145,31,143,31,73,31,171,31,129,31,136,31,9,31,65,31,55,31,210,31,36,31,132,31,227,31,227,30,63,31,9,31,210,31,204,31,103,31,103,30,96,31,1,31,115,31,223,31,213,31,104,31,150,31,163,31,163,30,51,31,6,31,176,31,5,31,208,31,249,31,19,31,254,31,152,31,238,31,235,31,198,31,132,31,101,31,172,31,172,30,237,31,12,31,12,30,130,31,83,31,173,31,173,30,173,29,22,31,22,30,219,31,148,31,45,31,224,31,224,30,23,31,23,30,183,31,130,31,12,31,166,31,3,31,78,31,3,31,14,31,14,30,171,31,154,31,155,31,161,31,66,31,212,31,212,30,73,31,73,30,251,31,251,30,190,31,88,31,61,31,61,30,61,29,248,31,190,31,190,30,190,29,121,31,147,31,206,31,103,31,150,31,150,30,191,31,20,31,118,31,106,31,195,31,60,31,171,31,139,31,139,30,139,29,203,31,126,31,18,31,254,31,8,31,248,31,248,30,202,31,48,31,48,30,44,31,100,31,100,30,100,29,100,28,209,31,209,30,190,31,242,31,59,31,200,31,149,31,222,31,3,31,202,31,98,31,187,31,197,31,197,30,124,31,212,31,167,31,138,31,178,31,126,31,129,31,217,31,70,31,86,31,6,31,184,31,184,30,88,31,79,31,70,31,56,31,144,31,201,31,28,31,95,31,182,31,93,31,98,31,78,31,193,31,154,31,40,31,40,30,155,31,38,31,110,31,110,30,110,29,235,31,67,31,67,30,67,29,22,31,17,31,17,30,17,29,152,31,176,31,179,31,3,31,89,31,105,31,105,30,105,31,138,31,107,31,250,31,250,30,93,31,47,31,47,30,159,31,159,30,119,31,48,31,78,31,78,30,78,29,78,28,173,31,173,30,136,31,18,31,18,30,18,29,53,31,129,31,224,31,224,30,52,31,152,31,124,31,170,31,1,31,15,31,112,31,254,31,88,31,245,31,197,31,208,31,184,31,220,31,253,31,167,31,103,31,199,31,177,31,229,31,226,31,39,31,9,31,49,31,8,31,8,30,225,31,28,31,28,30,21,31,21,30,21,29,103,31,103,30,10,31,73,31,166,31,143,31,51,31,138,31,5,31,43,31,16,31,111,31,5,31,167,31,56,31,56,30,242,31,106,31,210,31,106,31,106,30,195,31,195,30,180,31,66,31,105,31,46,31,207,31,83,31,83,30,83,29,138,31,219,31,38,31,246,31,30,31,240,31,240,30,49,31,47,31,225,31,54,31,76,31,241,31,241,30,241,29,88,31,88,30,67,31,39,31,39,30,255,31,162,31,77,31,77,30,77,29,77,28,228,31,175,31,79,31,79,30,146,31,222,31,145,31,145,30,145,29,180,31,180,30,180,29,90,31,246,31,246,30,74,31,251,31,251,30,251,29,193,31,206,31,17,31,141,31,239,31,70,31,159,31,185,31,236,31,16,31,214,31,46,31,46,30,123,31,118,31,117,31,65,31,47,31,233,31,139,31,186,31,94,31,173,31,173,30,173,29,25,31,121,31,186,31,186,30,186,31,52,31,123,31,240,31,107,31,39,31,170,31,170,30,35,31,166,31,11,31,59,31,59,30,59,29,238,31,172,31,172,30,60,31,201,31,217,31);

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
