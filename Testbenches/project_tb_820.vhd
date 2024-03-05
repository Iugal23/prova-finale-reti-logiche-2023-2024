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

constant SCENARIO_LENGTH : integer := 288;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (68,0,60,0,115,0,47,0,143,0,81,0,27,0,0,0,10,0,121,0,47,0,168,0,116,0,103,0,173,0,152,0,239,0,143,0,30,0,190,0,58,0,40,0,35,0,245,0,43,0,110,0,0,0,51,0,25,0,0,0,17,0,155,0,0,0,0,0,91,0,96,0,0,0,0,0,108,0,86,0,156,0,68,0,0,0,171,0,211,0,66,0,98,0,139,0,96,0,118,0,30,0,194,0,122,0,250,0,51,0,0,0,214,0,179,0,83,0,181,0,206,0,96,0,210,0,230,0,144,0,207,0,132,0,38,0,183,0,0,0,151,0,0,0,41,0,51,0,170,0,7,0,72,0,67,0,226,0,18,0,33,0,26,0,45,0,141,0,205,0,245,0,111,0,187,0,69,0,210,0,179,0,1,0,43,0,60,0,5,0,112,0,8,0,240,0,42,0,161,0,11,0,166,0,60,0,206,0,99,0,127,0,145,0,75,0,26,0,146,0,246,0,10,0,184,0,254,0,191,0,110,0,0,0,222,0,195,0,0,0,0,0,173,0,223,0,0,0,188,0,237,0,194,0,54,0,245,0,2,0,56,0,237,0,0,0,28,0,171,0,223,0,123,0,223,0,241,0,134,0,235,0,71,0,178,0,219,0,50,0,0,0,221,0,209,0,108,0,132,0,0,0,191,0,126,0,201,0,90,0,0,0,239,0,254,0,67,0,62,0,80,0,135,0,186,0,96,0,73,0,192,0,0,0,66,0,0,0,232,0,225,0,14,0,159,0,0,0,8,0,191,0,14,0,254,0,186,0,0,0,99,0,244,0,0,0,124,0,134,0,235,0,0,0,168,0,0,0,200,0,220,0,96,0,10,0,0,0,0,0,226,0,200,0,141,0,193,0,128,0,80,0,138,0,238,0,171,0,180,0,0,0,155,0,254,0,197,0,212,0,0,0,192,0,250,0,141,0,97,0,0,0,14,0,0,0,156,0,0,0,19,0,189,0,148,0,166,0,65,0,25,0,14,0,182,0,152,0,0,0,16,0,56,0,249,0,0,0,17,0,21,0,49,0,118,0,86,0,178,0,170,0,92,0,165,0,223,0,226,0,79,0,90,0,224,0,207,0,241,0,17,0,8,0,233,0,0,0,60,0,103,0,198,0,236,0,223,0,0,0,42,0,0,0,215,0,212,0,164,0,6,0,0,0,159,0,61,0,88,0,192,0,222,0,0,0,103,0,175,0,132,0,0,0,27,0,53,0,0,0,119,0,0,0,35,0,67,0,0,0,186,0,56,0,232,0);
signal scenario_full  : scenario_type := (68,31,60,31,115,31,47,31,143,31,81,31,27,31,27,30,10,31,121,31,47,31,168,31,116,31,103,31,173,31,152,31,239,31,143,31,30,31,190,31,58,31,40,31,35,31,245,31,43,31,110,31,110,30,51,31,25,31,25,30,17,31,155,31,155,30,155,29,91,31,96,31,96,30,96,29,108,31,86,31,156,31,68,31,68,30,171,31,211,31,66,31,98,31,139,31,96,31,118,31,30,31,194,31,122,31,250,31,51,31,51,30,214,31,179,31,83,31,181,31,206,31,96,31,210,31,230,31,144,31,207,31,132,31,38,31,183,31,183,30,151,31,151,30,41,31,51,31,170,31,7,31,72,31,67,31,226,31,18,31,33,31,26,31,45,31,141,31,205,31,245,31,111,31,187,31,69,31,210,31,179,31,1,31,43,31,60,31,5,31,112,31,8,31,240,31,42,31,161,31,11,31,166,31,60,31,206,31,99,31,127,31,145,31,75,31,26,31,146,31,246,31,10,31,184,31,254,31,191,31,110,31,110,30,222,31,195,31,195,30,195,29,173,31,223,31,223,30,188,31,237,31,194,31,54,31,245,31,2,31,56,31,237,31,237,30,28,31,171,31,223,31,123,31,223,31,241,31,134,31,235,31,71,31,178,31,219,31,50,31,50,30,221,31,209,31,108,31,132,31,132,30,191,31,126,31,201,31,90,31,90,30,239,31,254,31,67,31,62,31,80,31,135,31,186,31,96,31,73,31,192,31,192,30,66,31,66,30,232,31,225,31,14,31,159,31,159,30,8,31,191,31,14,31,254,31,186,31,186,30,99,31,244,31,244,30,124,31,134,31,235,31,235,30,168,31,168,30,200,31,220,31,96,31,10,31,10,30,10,29,226,31,200,31,141,31,193,31,128,31,80,31,138,31,238,31,171,31,180,31,180,30,155,31,254,31,197,31,212,31,212,30,192,31,250,31,141,31,97,31,97,30,14,31,14,30,156,31,156,30,19,31,189,31,148,31,166,31,65,31,25,31,14,31,182,31,152,31,152,30,16,31,56,31,249,31,249,30,17,31,21,31,49,31,118,31,86,31,178,31,170,31,92,31,165,31,223,31,226,31,79,31,90,31,224,31,207,31,241,31,17,31,8,31,233,31,233,30,60,31,103,31,198,31,236,31,223,31,223,30,42,31,42,30,215,31,212,31,164,31,6,31,6,30,159,31,61,31,88,31,192,31,222,31,222,30,103,31,175,31,132,31,132,30,27,31,53,31,53,30,119,31,119,30,35,31,67,31,67,30,186,31,56,31,232,31);

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
