-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_975 is
end project_tb_975;

architecture project_tb_arch_975 of project_tb_975 is
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

constant SCENARIO_LENGTH : integer := 365;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (129,0,2,0,104,0,159,0,60,0,128,0,109,0,164,0,171,0,142,0,154,0,116,0,132,0,148,0,37,0,154,0,46,0,245,0,0,0,160,0,211,0,222,0,151,0,255,0,247,0,23,0,0,0,0,0,0,0,140,0,183,0,244,0,103,0,0,0,130,0,68,0,46,0,155,0,158,0,232,0,218,0,0,0,71,0,214,0,211,0,107,0,138,0,171,0,68,0,147,0,0,0,183,0,38,0,214,0,213,0,111,0,196,0,0,0,26,0,203,0,164,0,0,0,202,0,111,0,157,0,121,0,21,0,111,0,101,0,21,0,90,0,189,0,219,0,0,0,29,0,0,0,65,0,66,0,25,0,159,0,130,0,0,0,213,0,217,0,0,0,114,0,0,0,87,0,148,0,0,0,38,0,193,0,87,0,97,0,88,0,149,0,126,0,17,0,209,0,0,0,72,0,187,0,153,0,55,0,229,0,113,0,220,0,88,0,251,0,197,0,0,0,196,0,69,0,30,0,88,0,20,0,121,0,155,0,20,0,91,0,0,0,0,0,184,0,0,0,30,0,44,0,0,0,0,0,250,0,251,0,122,0,182,0,172,0,141,0,98,0,48,0,66,0,152,0,82,0,118,0,179,0,119,0,147,0,67,0,173,0,0,0,0,0,163,0,223,0,97,0,143,0,31,0,0,0,102,0,111,0,48,0,0,0,83,0,224,0,33,0,0,0,43,0,255,0,149,0,237,0,48,0,82,0,10,0,0,0,53,0,3,0,57,0,205,0,183,0,0,0,38,0,0,0,243,0,30,0,24,0,234,0,20,0,204,0,115,0,0,0,37,0,217,0,146,0,25,0,120,0,0,0,121,0,0,0,0,0,244,0,55,0,212,0,253,0,53,0,0,0,31,0,115,0,70,0,24,0,65,0,40,0,199,0,0,0,0,0,239,0,11,0,72,0,125,0,76,0,95,0,76,0,9,0,174,0,220,0,0,0,11,0,224,0,42,0,54,0,0,0,111,0,243,0,212,0,243,0,187,0,104,0,4,0,146,0,87,0,15,0,242,0,3,0,145,0,204,0,35,0,242,0,67,0,0,0,98,0,14,0,6,0,0,0,155,0,99,0,164,0,111,0,142,0,110,0,46,0,45,0,182,0,197,0,211,0,208,0,85,0,241,0,0,0,52,0,241,0,0,0,22,0,78,0,250,0,0,0,0,0,62,0,221,0,36,0,161,0,175,0,238,0,75,0,143,0,184,0,167,0,9,0,0,0,24,0,62,0,0,0,18,0,0,0,182,0,0,0,0,0,175,0,224,0,77,0,244,0,50,0,66,0,177,0,0,0,81,0,252,0,199,0,66,0,114,0,163,0,157,0,0,0,246,0,233,0,24,0,56,0,16,0,241,0,0,0,227,0,114,0,1,0,120,0,93,0,168,0,60,0,0,0,0,0,185,0,127,0,27,0,118,0,59,0,4,0,28,0,56,0,135,0,165,0,0,0,248,0,209,0,71,0,190,0,167,0,0,0,223,0,143,0,0,0,170,0,59,0,0,0,0,0,216,0,225,0,195,0,198,0,0,0,141,0,0,0,118,0,91,0,104,0,90,0,155,0,72,0,198,0,197,0,149,0,228,0,0,0,100,0);
signal scenario_full  : scenario_type := (129,31,2,31,104,31,159,31,60,31,128,31,109,31,164,31,171,31,142,31,154,31,116,31,132,31,148,31,37,31,154,31,46,31,245,31,245,30,160,31,211,31,222,31,151,31,255,31,247,31,23,31,23,30,23,29,23,28,140,31,183,31,244,31,103,31,103,30,130,31,68,31,46,31,155,31,158,31,232,31,218,31,218,30,71,31,214,31,211,31,107,31,138,31,171,31,68,31,147,31,147,30,183,31,38,31,214,31,213,31,111,31,196,31,196,30,26,31,203,31,164,31,164,30,202,31,111,31,157,31,121,31,21,31,111,31,101,31,21,31,90,31,189,31,219,31,219,30,29,31,29,30,65,31,66,31,25,31,159,31,130,31,130,30,213,31,217,31,217,30,114,31,114,30,87,31,148,31,148,30,38,31,193,31,87,31,97,31,88,31,149,31,126,31,17,31,209,31,209,30,72,31,187,31,153,31,55,31,229,31,113,31,220,31,88,31,251,31,197,31,197,30,196,31,69,31,30,31,88,31,20,31,121,31,155,31,20,31,91,31,91,30,91,29,184,31,184,30,30,31,44,31,44,30,44,29,250,31,251,31,122,31,182,31,172,31,141,31,98,31,48,31,66,31,152,31,82,31,118,31,179,31,119,31,147,31,67,31,173,31,173,30,173,29,163,31,223,31,97,31,143,31,31,31,31,30,102,31,111,31,48,31,48,30,83,31,224,31,33,31,33,30,43,31,255,31,149,31,237,31,48,31,82,31,10,31,10,30,53,31,3,31,57,31,205,31,183,31,183,30,38,31,38,30,243,31,30,31,24,31,234,31,20,31,204,31,115,31,115,30,37,31,217,31,146,31,25,31,120,31,120,30,121,31,121,30,121,29,244,31,55,31,212,31,253,31,53,31,53,30,31,31,115,31,70,31,24,31,65,31,40,31,199,31,199,30,199,29,239,31,11,31,72,31,125,31,76,31,95,31,76,31,9,31,174,31,220,31,220,30,11,31,224,31,42,31,54,31,54,30,111,31,243,31,212,31,243,31,187,31,104,31,4,31,146,31,87,31,15,31,242,31,3,31,145,31,204,31,35,31,242,31,67,31,67,30,98,31,14,31,6,31,6,30,155,31,99,31,164,31,111,31,142,31,110,31,46,31,45,31,182,31,197,31,211,31,208,31,85,31,241,31,241,30,52,31,241,31,241,30,22,31,78,31,250,31,250,30,250,29,62,31,221,31,36,31,161,31,175,31,238,31,75,31,143,31,184,31,167,31,9,31,9,30,24,31,62,31,62,30,18,31,18,30,182,31,182,30,182,29,175,31,224,31,77,31,244,31,50,31,66,31,177,31,177,30,81,31,252,31,199,31,66,31,114,31,163,31,157,31,157,30,246,31,233,31,24,31,56,31,16,31,241,31,241,30,227,31,114,31,1,31,120,31,93,31,168,31,60,31,60,30,60,29,185,31,127,31,27,31,118,31,59,31,4,31,28,31,56,31,135,31,165,31,165,30,248,31,209,31,71,31,190,31,167,31,167,30,223,31,143,31,143,30,170,31,59,31,59,30,59,29,216,31,225,31,195,31,198,31,198,30,141,31,141,30,118,31,91,31,104,31,90,31,155,31,72,31,198,31,197,31,149,31,228,31,228,30,100,31);

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
